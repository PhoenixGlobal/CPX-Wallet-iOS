//
//  ApexTransferManagerViewController.m
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexTransferManagerViewController.h"
#import "ApexTXIDModel.h"
#import "ApexTXRecorderModel.h"
#import "ApexSendMoneyViewModel.h"
#import "LXDScanCodeController.h"
#import "ApexPassWordConfirmAlertView.h"
#import "ApexTransferModel.h"
#import "ApexTransferHistoryManager.h"
#import "ETHTransferHistoryManager.h"

#import "ApexSendMoneyFromCell.h"
#import "ApexSendMoneyToCell.h"
#import "ApexSendMoneyAmountCell.h"
#import "ApexSendMoneyGasCell.h"

@interface ApexTransferManagerViewController () <UITableViewDelegate, UITableViewDataSource, LXDScanCodeControllerDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) ApexSendMoneyViewModel *viewModel;
@property (nonatomic, strong) NSNumber *confirmBlock;
@property (nonatomic, strong) ApexTXIDModel *txidModel;
@property (nonatomic, strong) NeomobileWallet *wallet;

@property (nonatomic, strong) id<ApexTransHistoryProtocal> historyManager;

@end

@implementation ApexTransferManagerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - ------life cycle------
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    [self setUI];
    
    [self handleEvent];
}

#pragma mark - ------private------
- (void)setNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.titleView = self.titleLable;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanBtn];
}

#pragma mark - ------eventResponse------
- (void)handleEvent
{
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        LXDScanCodeController *scanvc = [[LXDScanCodeController alloc] init];
        scanvc.scanDelegate = self;
        [self.navigationController pushViewController:scanvc animated:YES];
    }];
}

- (void)setUI
{
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.tableView];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-34.0f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenW - 30.0f, 40.0f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset([ApexUIHelper naviBarHeight]);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.sendBtn.mas_top);
    }];
}

#pragma mark ------ UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.0f;
    }
    else if (indexPath.section == 1) {
        return 80.0f;
    }
    else if (indexPath.section == 2) {
        return 90.0f;
    }
    else if (indexPath.section == 3) {
        return 140.0f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"fromCell";
        ApexSendMoneyFromCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ApexSendMoneyFromCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.walletNameStr = self.walletName;
        cell.addressStr = self.walletAddress;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *cellIdentifier = @"toCell";
        ApexSendMoneyToCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ApexSendMoneyToCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString *cellIdentifier = @"amountCell";
        ApexSendMoneyAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ApexSendMoneyAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        return cell;
    }
    else if (indexPath.section == 3) {
        static NSString *cellIdentifier = @"gasCell";
        ApexSendMoneyGasCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ApexSendMoneyGasCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        return cell;
    }
    return nil;
}

#pragma mark - ------delegate & datasource------
- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo{
    
//    NSString *toaddress = codeInfo;
//    self.toAddressTF.text = toaddress;
}

//#pragma mark - ------getter & setter------
//- (ApexSendMoneyViewModel *)viewModel{
//    if (!_viewModel) {
//        _viewModel = [[ApexSendMoneyViewModel alloc] init];
//        _viewModel.address = self.walletAddress;
//        _viewModel.ownerVC = self;
//        _viewModel.balanceModel = self.balanceModel;
//        _viewModel.currentEthNumber = @"0";
//    }
//    return _viewModel;
//}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_scanBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
    }
    return _scanBtn;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = SOLocalizedStringFromTable(@"Transfer", nil);
    }
    return _titleLable;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 20, 30)];
        [_backBtn setImage:[UIImage imageNamed:@"back-4"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setBackgroundColor:[ApexUIHelper mainThemeColor]];
        _sendBtn.layer.cornerRadius = 6.0f;
        _sendBtn.clipsToBounds = YES;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn setTitle:SOLocalizedStringFromTable(@"send", nil) forState:UIControlStateNormal];
    }
    return _sendBtn;
}

@end
