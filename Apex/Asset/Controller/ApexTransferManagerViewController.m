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
@property (nonatomic, strong) ApexTXIDModel *txidModel;
@property (nonatomic, strong) NeomobileWallet *wallet;

@property (nonatomic, copy) NSString *gasPriceGWei;

@property (nonatomic, strong) id <ApexTransHistoryProtocal> historyManager;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    [self setUI];
    [self handleEvent];
    [self requestWalletType];
}

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
    
    [[self.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self sendAction];
    }];
}

- (void)sendAction
{
    ApexSendMoneyToCell *toAddressCell = [self getToAdressCell];
    ApexSendMoneyAmountCell *amoutCell = [self getSendAmountCell];
    ApexSendMoneyGasCell *gasCell = [self getEthGasInfoCell];
    
    if ([self.walletManager isKindOfClass:ETHWalletManager.class]) {
        //判断gas
        if(self.viewModel.currentEthNumber.floatValue < gasCell.totalETHL.text.floatValue){
            [self showMessage:SOLocalizedStringFromTable(@"insufficentGas", nil)];
            return;
        }
        //eth地址有效性判断
        if (![NSString isAdress:toAddressCell.walletAddressTF.text]) {
            [self showMessage:SOLocalizedStringFromTable(@"Please enter the correct wallet address", nil)];
            return;
        }
        
    }else{
        //neo地址有效性判断
        NSString *decode = NeomobileDecodeAddress(toAddressCell.walletAddressTF.text, nil);
        if (decode == nil){
            [self showMessage:SOLocalizedStringFromTable(@"Please enter the correct wallet address", nil)];
            return;
        }
    }
    
    if (![NSString isMoneyNumber:amoutCell.sendNumTF.text]) {
        [self showMessage:SOLocalizedStringFromTable(@"InvalidateMoney", nil)];
    }else if (amoutCell.sendNumTF.text.floatValue > _balanceModel.value.floatValue) {
        [self showMessage:SOLocalizedStringFromTable(@"BalanceNotEnough", nil)];
    }else if ([toAddressCell.walletAddressTF.text isEqualToString:_walletAddress]){
        [self showMessage:SOLocalizedStringFromTable(@"InvalidateAddress", nil)];
    }else if ([toAddressCell.walletAddressTF.text isEqualToString:@""]) {
        [self showMessage:SOLocalizedStringFromTable(@"Please enter the correct wallet address", nil)];
    }else{
        //输入密码
        [ApexPassWordConfirmAlertView showEntryPasswordAlertAddress:_walletAddress walletManager:self.walletManager subTitle:@"" Success:^(id wallet) {
            
            self.viewModel.toAddress = toAddressCell.walletAddressTF.text;
            self.viewModel.amount = [amoutCell.sendNumTF.text isEqualToString:@""] ? @"0" : amoutCell.sendNumTF.text;
            
            if ([self.walletManager isKindOfClass:ETHWalletManager.class]) {
                [self.viewModel ethTransactionWithWallet:wallet];
            }else{
                [self.viewModel neoTransactionWithWallet:wallet];
            }
            
        } fail:^{
            [self showMessage:SOLocalizedStringFromTable(@"Password Error", nil)];
        }];
    }
}

- (void)setUI
{
    self.gasPriceGWei = @"0.00";
    
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

- (void)requestWalletType
{
    [self.viewModel updateEthValue];
    
    //区分类型
    if ([_walletManager isKindOfClass:ETHWalletManager.class]) {
        self.historyManager = [ETHTransferHistoryManager shareManager];
        
    }else{
        self.historyManager = [ApexTransferHistoryManager shareManager];
    }
    
    self.viewModel.historyManager = _historyManager;
    
    [self request];
}

- (void)request
{
    @weakify(self);
    [self.viewModel getCurrentGasPrice:^(NSString *gasPriceInGWei) {
        @strongify(self);
        
        self.gasPriceGWei = [NSString stringWithFormat:@"%.2f", gasPriceInGWei.floatValue];
        self.viewModel.gasSliderValue = [NSString stringWithFormat:@"%.2f", (gasPriceInGWei.floatValue) * 3];
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark ------ UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_walletManager isKindOfClass:ETHWalletManager.class]) {
        return 4;
    }
    return 3;
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
        
        cell.availableL.attributedText = [self getUserAvailableMoney];
        cell.unitL.text = [self getUnitString];
        
        return cell;
    }
    else if (indexPath.section == 3) {
        static NSString *cellIdentifier = @"gasCell";
        ApexSendMoneyGasCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ApexSendMoneyGasCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.gasGWei = self.gasPriceGWei;
        
        return cell;
    }
    return nil;
}

#pragma mark ------ LXDScanCodeControllerDelegate

- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo
{
    [self changeToAddress:codeInfo];
}

- (void)changeToAddress:(NSString *)toaddress
{
    ApexSendMoneyToCell *cell = [self getToAdressCell];
    cell.walletAddressTF.text = toaddress;
}

#pragma mark ------ getter-cell

- (ApexSendMoneyToCell *)getToAdressCell
{
    return (ApexSendMoneyToCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

- (ApexSendMoneyAmountCell *)getSendAmountCell
{
    return (ApexSendMoneyAmountCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
}

- (ApexSendMoneyGasCell *)getEthGasInfoCell
{
    return (ApexSendMoneyGasCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
}

#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_AmountCellDidClickSendMoney]){
        [self sendAllMoney];
    }
    else if ([eventName isEqualToString:RouteNameEvent_AmountCellDidEditSendMoney]) {
        [self amountChanged];
    }
    else if ([eventName isEqualToString:RouteNameEvent_GasCellDidValueChange]) {
        [self sliderValueChanged];
    }
}

- (void)sendAllMoney
{
    ApexSendMoneyAmountCell *cell = [self getSendAmountCell];
    cell.sendNumTF.text = self.balanceModel.value;
}

- (void)amountChanged
{
    ApexSendMoneyAmountCell *cell = [self getSendAmountCell];
    NSString *num = cell.sendNumTF.text;
    
    if ([num containsString:@"."]) {
        NSString *interger = [num componentsSeparatedByString:@"."].firstObject;
        NSString *decimal = [num componentsSeparatedByString:@"."].lastObject;
        if (decimal.length >= 8) {
            decimal = [decimal substringToIndex:8];
        }
        cell.sendNumTF.text = [NSString stringWithFormat:@"%@.%@", interger, decimal];
    }
}

- (NSMutableAttributedString *)getUserAvailableMoney
{
    NSMutableAttributedString *attrStr = nil;
    NSString *string = @"";
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        string = [NSString stringWithFormat:@"Amount (Available: %@)",self.balanceModel.value];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }else{
        string = [NSString stringWithFormat:@"交易金额 (可用数量: %@)",self.balanceModel.value];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([string rangeOfString:@":"].location+2, self.balanceModel.value.length)];
    
    return attrStr;
}

- (NSString *)getUnitString
{
    return [self.balanceModel getRelativeNeoAssetModel].symbol;
}

- (void)sliderValueChanged
{
    ApexSendMoneyGasCell *cell = [self getEthGasInfoCell];
    
    cell.currentGasPriceL.text = [NSString stringWithFormat:@"%.2lf Gwei", cell.gasSlider.value];
    
    NSString *total = [NSString DecimalFuncWithOperatorType:2 first:@(cell.gasSlider.value).stringValue secend:@"90000" value:0];
    
    total = [NSString DecimalFuncWithOperatorType:3 first:total secend:@"1000000000" value:0];
    
    cell.totalETHL.attributedText = [ApexUIHelper getTotalPrice:[NSString stringWithFormat:@"%.11f",total.floatValue]];
    self.viewModel.gasSliderValue = @(cell.gasSlider.value).stringValue;
}

#pragma mark - ------getter & setter------

- (ApexSendMoneyViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ApexSendMoneyViewModel alloc] init];
        _viewModel.address = self.walletAddress;
        _viewModel.ownerVC = self;
        _viewModel.balanceModel = self.balanceModel;
        _viewModel.currentEthNumber = @"0";
    }
    return _viewModel;
}

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
