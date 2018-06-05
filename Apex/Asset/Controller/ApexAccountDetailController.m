//
//  ApexAccountDetailController.m
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexAccountDetailController.h"
#import "ApexWalletDetailController.h"
#import "ApexAssetCell.h"
#import "ApexAccountStateModel.h"
#import "CYLEmptyView.h"

@interface ApexAccountDetailController ()
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) ApexAccountStateModel *accountModel;
@property (nonatomic, strong) CYLEmptyView *emptyV;
@property (nonatomic, strong) NSMutableArray *assetArr;
@end

@implementation ApexAccountDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self setNav];
    [self getLoacalAsset];
    [self requestAsset];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
}

#pragma mark - ------private------
- (void)initUI{
    self.title = self.walletModel.name;
    self.addressL.text = self.walletModel.address;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ApexAssetCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.accessoryBaseView addSubview:self.addressL];
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.addressL.superview);
    }];
}

- (void)setNav{
    [self.navigationController lt_setBackgroundColor:self.baseColor];
}

- (void)getLoacalAsset{
    self.assetArr = self.walletModel.assetArr;
}

- (void)requestAsset{
    @weakify(self);
    [ApexWalletManager getAccountStateWithAddress:self.walletModel.address Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        self.accountModel = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
        [self updateAssets:self.accountModel.balances];
        if (self.assetArr.count == 0) {
            [self.tableView addSubview:self.emptyV];
        }else{
            [self.emptyV removeFromSuperview];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView addSubview:self.emptyV];
    }];
}

- (void)updateAssets:(NSArray*)balanceArr{
    for (BalanceObject *remoteObj in balanceArr) {
        
        if ([remoteObj.asset containsString:@"0x"]) {
            remoteObj.asset = [remoteObj.asset stringByReplacingOccurrencesOfString:@"0x" withString:@""];
        }
        
        if (self.assetArr.count != 0) {
            BalanceObject *equalObj = nil;
            for (BalanceObject *localObj in [self.assetArr copy]) {
                if ([localObj.asset isEqualToString:remoteObj.asset]) {
                    equalObj = localObj;
                }
            }
            if (equalObj) {
                [self.assetArr removeObject:equalObj];
                [self.assetArr addObject:remoteObj];
            }
        }else{
            [self.assetArr addObject:remoteObj];
        }
    }
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.assetArr.count;
    return count == 0 ? 1 : count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.assetArr.count == 0) {
        cell.hidden = YES;
    }else{
        cell.model = self.assetArr[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexWalletDetailController *vc = [[ApexWalletDetailController alloc] init];
    vc.walletAddress = self.walletModel.address;
    vc.walletName = self.walletModel.name;
    vc.balanceModel = self.assetArr[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ------eventResponse------

#pragma mark - ------getter & setter------
- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc] init];
        _addressL.frame = CGRectMake(222,134,309,37);
        _addressL.textAlignment = NSTextAlignmentCenter;
        _addressL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _addressL.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    }
    return _addressL;
}

- (CYLEmptyView *)emptyV{
    if (!_emptyV) {
        _emptyV = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:@"暂无数据" refreshBlock:nil];
    }
    return _emptyV;
}

- (NSMutableArray *)assetArr{
    if (!_assetArr) {
        _assetArr = [NSMutableArray array];
    }
    return _assetArr;
}
@end
