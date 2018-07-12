//
//  ApexMineController.m
//  Apex
//
//  Created by chinapex on 2018/5/18.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexMineController.h"
#import "ApexTransactionRecordView.h"
#import "ApexSwitchHeaderBar.h"
#import "ApexManageWalletView.h"
#import "ApexWalletManageDetailController.h"
#import "ApexTransactionDetailController.h"

@interface ApexMineController ()
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) ApexSwitchHeaderBar *swithBar;
@property (nonatomic, strong) ApexTransactionRecordView *transactionView;
@property (nonatomic, strong) ApexManageWalletView *manageView;
@end

@implementation ApexMineController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
    [self.transactionView reloadTransactionData];
    [self.manageView reloadWalletData];
}

#pragma mark - ------private------
- (void)setUI{
    self.title = SOLocalizedStringFromTable(@"Main", nil);
    self.view.backgroundColor = [ApexUIHelper grayColor240];
    

    [self.view addSubview:self.backIV];
    [self.view addSubview:self.swithBar];
    [self.view addSubview:self.transactionView];
    [self.view addSubview:self.manageView];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight + 60);
    }];
    
    [self.swithBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backIV).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.transactionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIV.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [self.manageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIV.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
}

- (void)setNav{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------


#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_SwitchHeaderManageWallet]) {
        self.manageView.hidden = NO;
        self.transactionView.hidden = YES;
        [self.manageView reloadWalletData];
    }else if ([eventName isEqualToString:RouteNameEvent_SwitchHeaderTransactionRecord]){
        self.manageView.hidden = YES;
        self.transactionView.hidden = NO;
        [self.transactionView reloadTransactionData];
    }else if ([eventName isEqualToString:RouteNameEvent_ManageWalletTapDetail]){
        ApexWalletModel *model = userinfo[@"wallet"];
        ApexWalletManageDetailController *detailVC = [[ApexWalletManageDetailController alloc] init];
        detailVC.model = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if ([eventName isEqualToString:RouteNameEvent_TransactionRecordDetail]){
        ApexWalletModel *model = userinfo[@"wallet"];
        ApexTransactionDetailController *detailVC = [[ApexTransactionDetailController alloc] init];
        detailVC.model = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}


#pragma mark - ------getter & setter------
- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] init];
        _backIV.image = [UIImage imageNamed:@"barImage"];
    }
    return _backIV;
}

- (ApexSwitchHeaderBar *)swithBar{
    if (!_swithBar) {
        _swithBar = [[ApexSwitchHeaderBar alloc] init];
    }
    return _swithBar;
}

- (ApexTransactionRecordView *)transactionView{
    if (!_transactionView) {
        _transactionView = [[ApexTransactionRecordView alloc] init];
    }
    return _transactionView;
}

- (ApexManageWalletView *)manageView{
    if (!_manageView) {
        _manageView = [[ApexManageWalletView alloc] init];
    }
    return _manageView;
}

@end
