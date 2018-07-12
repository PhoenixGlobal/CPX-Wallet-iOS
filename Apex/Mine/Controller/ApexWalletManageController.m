//
//  ApexWalletManageController.m
//  Apex
//
//  Created by chinapex on 2018/7/12.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexWalletManageController.h"
#import "ApexManageWalletView.h"
#import "ApexWalletManageDetailController.h"

@interface ApexWalletManageController ()
@property (nonatomic, strong) ApexManageWalletView *manageView;
@end

@implementation ApexWalletManageController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController lt_setBackgroundColor:[ApexUIHelper navColor]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}


#pragma mark - ------private------
- (void)initUI{
    self.title = SOLocalizedStringFromTable(@"Manage Wallet", nil);
    [self.view addSubview:self.manageView];
    [self.manageView reloadWalletData];
}


#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_ManageWalletTapDetail]){
        ApexWalletModel *model = userinfo[@"wallet"];
        ApexWalletManageDetailController *detailVC = [[ApexWalletManageDetailController alloc] init];
        detailVC.model = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark - ------getter & setter------
- (ApexManageWalletView *)manageView{
    if (!_manageView) {
        _manageView = [[ApexManageWalletView alloc] initWithFrame:self.view.bounds];
    }
    return _manageView;
}
@end
