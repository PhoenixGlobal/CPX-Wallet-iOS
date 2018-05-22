//
//  ApexAssetController.m
//  Apex
//
//  Created by chinapex on 2018/5/18.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexAssetController.h"
#import "ApexWalletManager.h"
#import "ApexWalletCell.h"
#import "ApexWalletDetailController.h"
#import "ApexMorePanelView.h"
#import "ApexCreatWalletController.h"

#define RouteNameEvent_SendMoney @"RouteNameEvent_SendMoney"
#define RouteNameEvent_RequestMoney @"RouteNameEvent_RequestMoney"
#define RouteNameEvent_ShowMorePanel @"RouteNameEvent_ShowMorePanel"

@interface ApexAssetController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *contentArr;
@property (nonatomic, strong) UILabel *totalBalanceL;
@property (nonatomic, strong) UILabel *unitL;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) ApexMorePanelView *moreView;
@end

@implementation ApexAssetController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self setNav];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getWalletLists];
}


#pragma mark - ------private------
- (void)setNav{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = self.titleL;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
}

- (void)setUI{
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.totalBalanceL];
    [self.view addSubview:self.unitL];
    [self.view addSubview:self.moreView];
    
    self.totalBalanceL.hidden = YES;
    self.unitL.hidden = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ApexWalletCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIV.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.totalBalanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(70);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(50));
        make.height.mas_equalTo(scaleHeight667(60));
    }];
    
    [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.totalBalanceL);
        make.left.equalTo(self.totalBalanceL.mas_right).offset(20);
    }];
    
    self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self.collectionView reloadData];
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self.view);
    }];
    
    self.moreView.transform = CGAffineTransformMakeTranslation(-kScreenW, 0);
}

- (void)getWalletLists{
    _contentArr = [ApexWalletManager getWalletsArr];
    [self.collectionView reloadData];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ApexWalletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *str = _contentArr[indexPath.row];
    NSArray *arr = [str componentsSeparatedByString:@"/"];
    cell.walletNameStr = arr.lastObject;
    cell.addressStr = arr.firstObject;
    cell.didFinishRequestBalanceSub = [RACSubject subject];
    [[cell.didFinishRequestBalanceSub takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        [self.collectionView.mj_header endRefreshing];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ApexWalletDetailController *dvc = [[ApexWalletDetailController alloc] init];
    ApexWalletCell *cell = (ApexWalletCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *str = _contentArr[indexPath.row];
    NSArray *arr = [str componentsSeparatedByString:@"/"];
    dvc.walletName = arr.lastObject;
    dvc.walletAddress = arr.firstObject;
    dvc.accountModel = [cell getAccountInfo];
    dvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
   if([eventName isEqualToString:RouteNameEvent_ShowMorePanel]){
        _moreView.hidden = NO;
        _moreView.transform = CGAffineTransformIdentity;
    }else if ([eventName isEqualToString:RouteNameEvent_PanelViewScan]){
//        [self scanAction];
    }else if ([eventName isEqualToString:RouteNameEvent_PanelViewCreatWallet]){
        ApexCreatWalletController *wvc = [[ApexCreatWalletController alloc] init];
        wvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wvc animated:YES];
    }
}
#pragma mark - ------getter & setter------
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.frame = CGRectMake(152, 30, 72.5, 25);
        _titleL.text = @"资产";
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _titleL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _titleL;
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] init];
        _backIV.image = [UIImage imageNamed:@"Background"];
    }
    return _backIV;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        fl.itemSize = CGSizeMake(scaleWidth375(350), 100);
        fl.minimumLineSpacing = 10;
        fl.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.backgroundColor = [ApexUIHelper grayColor240];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return _collectionView;
}

- (UILabel *)totalBalanceL{
    if (!_totalBalanceL) {
        _totalBalanceL = [[UILabel alloc] init];
        _totalBalanceL.text = @"0";
        _totalBalanceL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:50];
        _totalBalanceL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
        _totalBalanceL.textAlignment = NSTextAlignmentCenter;
    }
    return _totalBalanceL;
}

- (UILabel *)unitL{
    if (!_unitL) {
        _unitL = [[UILabel alloc] init];
        _unitL.text = @"Neo";
        _unitL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _unitL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _unitL;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.frame = CGRectMake(0, 0, 40, 40);
        [_moreBtn setImage:[UIImage imageNamed:@"dots"] forState:UIControlStateNormal];
        [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteNameEvent_ShowMorePanel userInfo:@{}];
        }];
    }
    return _moreBtn;
}

- (ApexMorePanelView *)moreView{
    if (!_moreView) {
        _moreView = [[ApexMorePanelView alloc] init];
        _moreView.hidden = YES;
    }
    return _moreView;
}

@end
