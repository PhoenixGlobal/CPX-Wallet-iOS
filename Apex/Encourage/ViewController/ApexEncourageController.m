//
//  ApexEncourageController.m
//  Apex
//
//  Created by yulin chi on 2018/8/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexEncourageController.h"
#import "ApexRewardListTableViewCell.h"
#import "ApexEncourageSubmitViewController.h"
#import "ApexEncourageActivitysModel.h"
#import "CYLEmptyView.h"

#define layersSubtle 30.0

@interface ApexEncourageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArray;

@property (nonatomic, strong) UILabel *encourageLabel;
@property (nonatomic, strong) UIImageView *apexImageView;

@property (nonatomic, assign) CGFloat firstLayerDelta;
@property (nonatomic, assign) CGFloat translateOffset;
@property (nonatomic, assign) CGFloat translateLength;

@property (nonatomic, assign) double currentCpx; /**<  */
@property (nonatomic, strong) CYLEmptyView *emptyView;

@end

@implementation ApexEncourageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self getTotalAmountOfNep5];
    [self getActivityList];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [self.tableView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)initUI
{
    self.title = SOLocalizedStringFromTable(@"", nil);
    self.view.backgroundColor = [ApexUIHelper grayColor240];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    
    _datasArray = [NSMutableArray new];
    self.firstLayerDelta = scaleHeight667(200) - NavBarHeight;
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.apexImageView];
    [self.view addSubview:self.encourageLabel];
    
    [self.view addSubview:self.baseView];
    [self.view addSubview:self.tableView];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.apexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(NavBarHeight - 20.0f);
        make.size.mas_equalTo(CGSizeMake(100.0f, 23.0f));
    }];
    
    [self.encourageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15.0f);
        make.top.equalTo(self.view).with.offset(scaleHeight667(200)-60.0f);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(scaleHeight667(200));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(NavBarHeight);
        make.left.equalTo(self.view).with.offset(15.0f);
        make.right.equalTo(self.view).with.offset(-15.0f);
        make.bottom.equalTo(self.view).with.offset(-[ApexUIHelper tabBarHeight]);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(_firstLayerDelta - layersSubtle, 0, (IS_IPHONE_X ? 34.0f : 0), 0);
    self.tableView.contentOffset = CGPointMake(0, -(_firstLayerDelta - layersSubtle));
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self getTotalAmountOfNep5];
        [self getActivityList];
    }];
    
    [self.tableView registerClass:[ApexRewardListTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.translateOffset = -99999;
    self.currentCpx = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *x = change[NSKeyValueChangeNewKey];
        
        CGFloat offSetY = x.CGPointValue.y;
        if (self.translateOffset == -99999) {
            self.translateOffset = offSetY;
        }
        
        CGFloat percent = ((offSetY + fabs(self.translateOffset))/self.translateLength);
        
        if (percent < 0) {
            self.title = SOLocalizedStringFromTable(@"", nil);
            
            self.encourageLabel.alpha = 1;
            self.apexImageView.alpha = 1;
            self.baseView.backgroundColor = [UIColor clearColor];
            
            self.baseView.transform = CGAffineTransformMakeTranslation(0, -self.firstLayerDelta*percent*0.8);
        }
        else if (percent >= 0 && percent <= 0.8) {
            self.title = SOLocalizedStringFromTable(@"", nil);
            
            self.encourageLabel.alpha = 1 - percent;
            self.apexImageView.alpha = 1 - percent;
            self.baseView.backgroundColor = [ApexUIHelper grayColor240];
            
            self.baseView.transform = CGAffineTransformMakeTranslation(0, -self.firstLayerDelta*percent*1.25);
        }
        else {
            self.title = SOLocalizedStringFromTable(@"Reward", nil);
            
            self.encourageLabel.alpha = 0;
            self.apexImageView.alpha = 0;
            self.baseView.backgroundColor = [ApexUIHelper grayColor240];
            
            self.baseView.transform = CGAffineTransformMakeTranslation(0, -_firstLayerDelta);
        }
    }
    else if ([keyPath isEqualToString:@"contentSize"]){
        NSValue *x = change[NSKeyValueChangeNewKey];
        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(scaleHeight667(200));
            make.height.mas_equalTo(x.CGSizeValue.height <= kScreenH ? kScreenH*2 : x.CGSizeValue.height);
        }];
    }
}

- (void)getTotalAmountOfNep5
{
    NSMutableArray *addressArray = [NSMutableArray new];
    NSArray *walletArray = [[ApexWalletManager shareManager] getWalletsArr];
    for (NSInteger i = 0; i < walletArray.count; i++) {
        ApexWalletModel *model = [walletArray objectAtIndex:i];
        [addressArray addObject:model.address];
    }
    
    [ApexWalletManager getTotalAmountOfNep5Asset:assetId_CPX onAddresses:addressArray Success:^(AFHTTPRequestOperation *operation, NSNumber *responseObject) {
        [_tableView.mj_header endRefreshing];
        _currentCpx = responseObject.doubleValue;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)getActivityList
{
    [self.datasArray removeAllObjects];
    [CYLNetWorkManager GET:@"activities/list/" parameter:nil success:^(CYLResponse *response) {
        [_tableView.mj_header endRefreshing];
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *activityArray = resultDictionary[@"data"];
        for (NSDictionary *dict in activityArray) {
            ApexEncourageActivitysModel *model = [ApexEncourageActivitysModel yy_modelWithDictionary:dict];
            [self.datasArray addObject:model];
        }
        
        if (self.datasArray.count > 0) {
            [self clearEmptyView];
        }
        else {
            [self showEmptyView];
        }
        
        [_tableView reloadData];
        
    } fail:^(NSError *error) {
        [self showEmptyView];
        
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    }];
}

#pragma mark ------ UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasArray.count > indexPath.section) {
        ApexEncourageActivitysModel *model = (ApexEncourageActivitysModel *)[self.datasArray objectAtIndex:indexPath.section];
        return [ApexRewardListTableViewCell getContentHeightWithDictionary:model];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApexRewardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.datasArray.count > indexPath.section) {
        ApexEncourageActivitysModel *model = (ApexEncourageActivitysModel *)[_datasArray objectAtIndex:indexPath.section];
        [cell updaetRewardWithDictionary:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasArray.count > indexPath.section) {
        ApexEncourageActivitysModel *model = (ApexEncourageActivitysModel *)[self.datasArray objectAtIndex:indexPath.section];
        NSString *isProgress = [NSString stringWithFormat:@"%@", model.status];
        if ([isProgress isEqualToString:@"1"]) {
            ApexEncourageSubmitViewController *submitViewController = [[ApexEncourageSubmitViewController alloc] init];
            submitViewController.activityModel = model;
            submitViewController.currentCpx = self.currentCpx;
            submitViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:submitViewController animated:YES];
        }
    }
}

#pragma mark ------Setter
- (void)setFirstLayerDelta:(CGFloat)firstLayerDelta{
    _firstLayerDelta = firstLayerDelta;
    _translateLength = _firstLayerDelta - layersSubtle;
}

- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor clearColor];
    }
    return _baseView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"encourage-background"];
    }
    
    return _backgroundImageView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor clearColor];
    }

    return _tableView;
}

- (UILabel *)encourageLabel
{
    if (!_encourageLabel) {
        _encourageLabel = [[UILabel alloc] init];
        _encourageLabel.font = [UIFont systemFontOfSize:18];
        _encourageLabel.textColor = [UIColor whiteColor];
        _encourageLabel.text = SOLocalizedStringFromTable(@"Reward", nil);
    }
    
    return _encourageLabel;
}

- (UIImageView *)apexImageView
{
    if (!_apexImageView) {
        _apexImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apexTitle"]];
    }
    
    return _apexImageView;
}

#pragma mark ------ empty
- (void)showEmptyView
{
    if (!self.emptyView) {
        self.emptyView = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:SOLocalizedStringFromTable(@"Data Empty", nil) refreshBlock:nil];
    }
}

- (void)clearEmptyView
{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
}

@end
