//
//  ApexAssetMainController.m
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexAssetMainController.h"
#import "ApexWalletManager.h"
#import "ApexAssetMainViewCell.h"
#import "ApexCreatWalletController.h"
#import "ApexSearchWalletToolBar.h"
#import "CYLEmptyView.h"
#import "ApexAccountDetailController.h"

@interface ApexAssetMainController ()
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) CYLEmptyView *emptyV;
@property (nonatomic, strong) ApexSearchWalletToolBar *searchTooBar;
@end

@implementation ApexAssetMainController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getWalletLists];
    [self setNav];
}
#pragma mark - ------private------
- (void)initUI{
    self.view.backgroundColor = self.baseColor;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ApexAssetMainViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.accessoryBaseView addSubview:self.searchTooBar];
    [self.searchTooBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchTooBar.superview);
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView.mj_header setTintColor:[UIColor whiteColor]];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)setNav{
    self.title = @"资产";
    [self.navigationController lt_setBackgroundColor:self.baseColor];
}

- (void)getWalletLists{
    [self.searchTooBar clearEntrance];
    _contentArr = [ApexWalletManager getWalletsArr];
    [self.tableView reloadData];
}
#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexAssetMainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ApexWalletModel *model = _contentArr[indexPath.section];
    cell.walletNameStr = model.name;
    cell.addressStr = model.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexWalletModel *model = self.contentArr[indexPath.section];
    ApexAccountDetailController *vc = [[ApexAccountDetailController alloc] init];
    vc.walletModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    @weakify(self);
    self.searchTooBar.textDidChangeSub = [RACSubject subject];
    [[self.searchTooBar.textDidChangeSub takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *key) {
        @strongify(self);
        if (key.length == 0) {
            self.contentArr = [ApexWalletManager getWalletsArr];
            [self.emptyV removeFromSuperview];
            self.emptyV = nil;
            [self.tableView reloadData];
            return;
        }
        
        [self.contentArr removeAllObjects];
        
        for (ApexWalletModel *wallet in [ApexWalletManager getWalletsArr]) {
            
            if ([wallet.name containsString:key]) {
                [self.contentArr addObject:wallet];
            }
        }
        
        if (self.contentArr.count == 0) {
            if (!self.emptyV) {
                self.emptyV = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:@"暂无数据" refreshBlock:nil];
            }
        }else{
            [self.emptyV removeFromSuperview];
            self.emptyV = nil;
        }
        [self.tableView reloadData];
        
    }];
}
#pragma mark - ------getter & setter------
- (ApexSearchWalletToolBar *)searchTooBar{
    if (!_searchTooBar) {
        _searchTooBar = [[ApexSearchWalletToolBar alloc] init];
    }
    return _searchTooBar;
}
@end
