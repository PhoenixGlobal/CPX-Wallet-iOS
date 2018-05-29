//
//  ApexTransactionDetailController.m
//  Apex
//
//  Created by chinapex on 2018/5/29.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTransactionDetailController.h"
#import "ApexSearchWalletToolBar.h"
#import "ApexAccountStateModel.h"
#import "ApexTransferCell.h"
#import "ApexTransferDetailHeader.h"
#import "CYLEmptyView.h"

@interface ApexTransactionDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIView *searchBaseV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *swithBtn;
@property (nonatomic, strong) ApexSearchWalletToolBar *searchToolBar;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) CYLEmptyView *ev;
@end

@implementation ApexTransactionDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self handleEvent];
    [self requestBalance];
    [self prepareData];
}

#pragma mark - ------private------
- (void)initUI{
    
    self.title = self.model.name;
    self.addressL.text = self.model.address;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.swithBtn];
    [self.searchBaseV addSubview:self.searchToolBar];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ApexTransferCell class] forCellReuseIdentifier:@"cell"];
}

- (void)requestBalance{
    @weakify(self);
    [ApexWalletManager getAccountStateWithAddress:self.model.address Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        ApexAccountStateModel *model = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
        model.balances.count == 0 ? (self.balance.text = @"0") : (self.balance.text = model.balances.firstObject.value);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.balance.text = @"N/A";
    }];
}

- (void)prepareData{
    NSArray *arr = [TKFileManager loadDataWithFileName:TXRECORD_KEY];
    for (ApexTXRecorderModel *model in arr) {
        if ([model.fromAddress isEqualToString:self.model.address]) {
            [self.contentArr addObject:model];
        }
    }
    
    if (_contentArr.count == 0) {
        self.ev = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:@"暂无交易记录" refreshBlock:nil];
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.contentArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ApexTransferDetailHeader *h = [[ApexTransferDetailHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    self.searchToolBar.textDidChangeSub = [RACSubject subject];
    [self.searchToolBar.textDidChangeSub subscribeNext:^(NSString *address) {
        
    }];
}

#pragma mark - ------getter & setter------
- (UIButton *)swithBtn{
    if (!_swithBtn) {
        _swithBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _swithBtn;
}

- (ApexSearchWalletToolBar *)searchToolBar{
    if (!_searchToolBar) {
        _searchToolBar = [[ApexSearchWalletToolBar alloc] initWithFrame:self.searchBaseV.bounds];
    }
    return _searchToolBar;
}

- (NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
@end
