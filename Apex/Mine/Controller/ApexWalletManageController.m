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
#import "ApexNoWalletView.h"

@interface ApexWalletManageController ()
@property (nonatomic, strong) ApexManageWalletView *manageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *fakeNavBar; /**<  */
@property (nonatomic, strong) ApexNoWalletView *noWalletView; /**<  */
@end

@implementation ApexWalletManageController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.manageView reloadWalletData];
    [self setNav];
    [self judgeIfHadWallet];
}

#pragma mark - ------private------
- (void)initUI{
    self.navigationItem.titleView = self.titleL;
    [self.view addSubview:self.manageView];
    [self.view addSubview:self.fakeNavBar];
    
    [self.fakeNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight);
    }];
    
    [self.manageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fakeNavBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

- (void)setNav{
    UIImage *image = [UIImage imageNamed:@"back-4"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)judgeIfHadWallet{
    NSMutableArray *arr = [ApexWalletManager getWalletsArr];
    [arr addObject:[ETHWalletManager getWalletsArr]];
    if (arr.count == 0) {
        [self.manageView addSubview:self.noWalletView];
        [self.noWalletView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.manageView);
        }];
        self.noWalletView.hidden = NO;
    }else{
        self.noWalletView.hidden = YES;
    }
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
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleL.text = SOLocalizedStringFromTable(@"Manage Wallet", nil);
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}

- (UIImageView *)fakeNavBar{
    if (!_fakeNavBar) {
        _fakeNavBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barImage"]];
    }
    return _fakeNavBar;
}

- (ApexNoWalletView *)noWalletView{
    if (!_noWalletView) {
        _noWalletView = [[ApexNoWalletView alloc] init];
        [_noWalletView setMessage:SOLocalizedStringFromTable(@"Data Empty", nil)];
        [_noWalletView setBtnHidden:YES];
    }
    return _noWalletView;
}
@end
