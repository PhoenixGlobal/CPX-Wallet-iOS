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
#import "ApexCreatWalletController.h"
#import "ApexSearchWalletToolBar.h"

#define RouteNameEvent_SendMoney @"RouteNameEvent_SendMoney"
#define RouteNameEvent_RequestMoney @"RouteNameEvent_RequestMoney"
#define RouteNameEvent_ShowMorePanel @"RouteNameEvent_ShowMorePanel"

@interface ApexAssetController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) UILabel *totalBalanceL;
@property (nonatomic, strong) UILabel *unitL;
@property (nonatomic, strong) ApexSearchWalletToolBar *searchTooBar;
@end

@implementation ApexAssetController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self setNav];
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getWalletLists];
}


#pragma mark - ------private------
- (void)setNav{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = self.titleL;
}

- (void)setUI{
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.totalBalanceL];
    [self.view addSubview:self.unitL];
    
    [self.view addSubview:self.searchTooBar];
    
    self.totalBalanceL.hidden = YES;
    self.unitL.hidden = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ApexWalletCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight + 60);
    }];
    
    [self.searchTooBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backIV).offset(-10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
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
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)getWalletLists{
    [self.searchTooBar clearEntrance];
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
//    cell.didFinishRequestBalanceSub = [RACSubject subject];
//    [[cell.didFinishRequestBalanceSub takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(ApexAccountStateModel *accountModel) {
//        [self.collectionView.mj_header endRefreshing];
//    }];
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

}

- (void)handleEvent{
    self.searchTooBar.textDidChangeSub = [RACSubject subject];
    [[self.searchTooBar.textDidChangeSub takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *key) {
        
        if (key.length == 0) {
            self.contentArr = [ApexWalletManager getWalletsArr];
            [self.collectionView reloadData];
            return;
        }
        
        [self.contentArr removeAllObjects];
        
        for (NSString *name in [ApexWalletManager getWalletsArr]) {
            NSArray *arr = [name componentsSeparatedByString:@"/"];
            NSString *addressName = arr.lastObject;
            if ([addressName hasPrefix:key]) {
                [self.contentArr addObject:name];
            }
        }
        [self.collectionView reloadData];
    }];
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

- (ApexSearchWalletToolBar *)searchTooBar{
    if (!_searchTooBar) {
        _searchTooBar = [[ApexSearchWalletToolBar alloc] init];
    }
    return _searchTooBar;
}

@end
