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
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation ApexWalletManageController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.manageView reloadWalletData];
    [self setNav];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


#pragma mark - ------private------
- (void)initUI{
    self.navigationItem.titleView = self.titleL;
    [self.view addSubview:self.manageView];
}

- (void)setNav{
    UIImage *image = [UIImage imageNamed:@"back-4"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ------getter & setter------
- (ApexManageWalletView *)manageView{
    if (!_manageView) {
        _manageView = [[ApexManageWalletView alloc] initWithFrame:self.view.bounds];
    }
    return _manageView;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = SOLocalizedStringFromTable(@"Manage Wallet", nil);
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}
@end
