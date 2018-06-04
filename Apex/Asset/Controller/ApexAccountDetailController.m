//
//  ApexAccountDetailController.m
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexAccountDetailController.h"
#import "ApexAssetCell.h"
#import "ApexAccountStateModel.h"
#import "CYLEmptyView.h"

@interface ApexAccountDetailController ()
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) ApexAccountStateModel *accountModel;
@property (nonatomic, strong) CYLEmptyView *emptyV;
@end

@implementation ApexAccountDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self requestBalance];
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

- (void)requestBalance{
    @weakify(self);
    [ApexWalletManager getAccountStateWithAddress:self.walletModel.address Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        self.accountModel = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
        if (self.accountModel.balances.count == 0) {
            [self.tableView addSubview:self.emptyV];
        }else{
            [self.emptyV removeFromSuperview];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView addSubview:self.emptyV];
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.accountModel.balances.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.accountModel.balances[indexPath.row];
    return cell;
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
@end
