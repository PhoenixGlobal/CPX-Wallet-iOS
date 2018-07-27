//
//  ApexTransactionRecordView.m
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTransactionRecordView.h"
#import "ApexWallerItemCell.h"

@interface ApexTransactionRecordView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentArr;
@end

@implementation ApexTransactionRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - private
- (void)initUI{
    self.tableView.backgroundColor = [ApexUIHelper grayColor240];
    self.backgroundColor = [ApexUIHelper grayColor240];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self).offset(10);
        }else{
            make.top.equalTo(self).offset(-NavBarHeight+10);
        }
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ApexWallerItemCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)reloadTransactionData{
    self.contentArr = [ApexWalletManager getWalletsArr];
    [self.tableView reloadData];
}

#pragma mark - delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexWallerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ApexWalletModel *model = _contentArr[indexPath.section];
    cell.model = model;
    cell.backupTipBtn.hidden = YES;
    //    cell.didFinishRequestBalanceSub = [RACSubject subject];
    //    [[cell.didFinishRequestBalanceSub takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(ApexAccountStateModel *accountModel) {
    //
    //    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self routeEventWithName:RouteNameEvent_TransactionRecordDetail userInfo:@{@"wallet":_contentArr[indexPath.section]}];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 7)];
    v.backgroundColor = [ApexUIHelper grayColor240];
    return v;
}

#pragma mark - getter setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
@end
