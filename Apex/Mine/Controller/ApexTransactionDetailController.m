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
#import "ApexSwithWalletView.h"

@interface ApexTransactionDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIView *searchBaseV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewH;

@property (nonatomic, strong) UIButton *swithBtn;
@property (nonatomic, strong) ApexSearchWalletToolBar *searchToolBar;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) NSArray *walletArr;
@property (nonatomic, strong) CYLEmptyView *ev;
@property (nonatomic, strong) NSArray *allTxArr;
@property (nonatomic, strong) ApexSwithWalletView *switchView;
@end

@implementation ApexTransactionDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareData];
}

#pragma mark - ------private------
- (void)initUI{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.swithBtn];
    [self.searchBaseV addSubview:self.searchToolBar];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ApexTransferCell class] forCellReuseIdentifier:@"cell"];
    
    self.baseViewH.constant = NavBarHeight+ 60;
}

//- (void)requestBalance{
//    @weakify(self);
//    [ApexWalletManager getAccountStateWithAddress:self.model.address Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        @strongify(self);
//        ApexAccountStateModel *model = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
//        model.balances.count == 0 ? (self.balance.text = @"0") : (self.balance.text = model.balances.firstObject.value);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        self.balance.text = @"N/A";
//    }];
//}

- (void)prepareData{
    self.title = self.model.name;
    self.addressL.text = self.model.address;
    
    self.allTxArr = [TKFileManager loadDataWithFileName:TXRECORD_KEY];
    self.walletArr = [ApexWalletManager getWalletsArr];
    [self.contentArr removeAllObjects];
    
    for (ApexTXRecorderModel *model in _allTxArr) {
        if ([model.fromAddress isEqualToString:self.model.address]) {
            [self.contentArr addObject:model];
        }
    }
    
    if (_contentArr.count == 0) {
        self.ev = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:@"暂无交易记录" refreshBlock:nil];
    }else{
        [self.ev removeFromSuperview];
    }
    
    if (self.walletArr.count == 1) {
        self.swithBtn.hidden = YES;
    }
    else{
        self.swithBtn.hidden = NO;
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    ApexTransferDetailHeader *h = [[ApexTransferDetailHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
//    return h;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    @weakify(self);
    self.searchToolBar.textDidChangeSub = [RACSubject subject];
    [self.searchToolBar.textDidChangeSub subscribeNext:^(NSString *key) {
        
        if (key.length == 0) {
            [self prepareData];
        }else{
            NSMutableArray *tempArr = [NSMutableArray array];
            for (ApexTXRecorderModel *model in self.allTxArr) {
                if ([model.toAddress containsString:key]) {
                    [tempArr addObject:model];
                }
            }
            self.contentArr = tempArr;
            [self.tableView reloadData];
        }
    }];
    
    [[self.swithBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.swithBtn.selected = !self.swithBtn.selected;
        self.switchView.contentArr = self.walletArr;
        [[UIApplication sharedApplication].keyWindow addSubview:self.switchView];
    }];
    
    self.switchView.didSwitchSub = [RACSubject subject];
    [self.switchView.didSwitchSub subscribeNext:^(ApexWalletModel *x) {
        self.model = x;
        [self prepareData];
    }];
}

#pragma mark - ------getter & setter------
- (UIButton *)swithBtn{
    if (!_swithBtn) {
        _swithBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_swithBtn setImage:[UIImage imageNamed:@"Group 2-1"] forState:UIControlStateNormal];
        _swithBtn.selected = false;
    }
    return _swithBtn;
}

- (ApexSearchWalletToolBar *)searchToolBar{
    if (!_searchToolBar) {
        _searchToolBar = [[ApexSearchWalletToolBar alloc] initWithFrame:self.searchBaseV.bounds];
        _searchToolBar.placeHolder = @"搜索转账地址";
    }
    return _searchToolBar;
}

- (NSArray *)walletArr{
    if (!_walletArr) {
        _walletArr = [NSArray array];
    }
    return _walletArr;
}

- (NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}

- (ApexSwithWalletView *)switchView{
    if (!_switchView) {
        _switchView = [[ApexSwithWalletView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _switchView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _switchView;
}
@end
