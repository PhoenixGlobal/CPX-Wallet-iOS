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
#import "ApexTransferHistoryManager.h"
#import "ApexTXDetailController.h"
#import "ApexChangeBindWalletController.h"

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
@property (nonatomic, strong) ApexSwithWalletView *switchView;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation ApexTransactionDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self handleEvent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TranferStatusHasChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TranferHasConfirmed object:nil];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferStatusHasChanged) name:Notification_TranferStatusHasChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTXHistory) name:Notification_TranferHasConfirmed object:nil];
}

#pragma mark - ------private------
- (void)initUI{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.swithBtn];
    [self.searchBaseV addSubview:self.searchToolBar];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ApexTransferCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self requestTXHistory];
    }];
    [self.tableView.mj_header setAutomaticallyChangeAlpha:YES];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self requestNextPage];
    }];
    
    self.baseViewH.constant = NavBarHeight+ 60;
    
    //获取本地信息
    [self requestSuccessLoadDataFromFMDB];
}

- (void)prepareData{
    self.title = self.model.name;
    self.addressL.text = self.model.address;
    self.walletArr = [ApexWalletManager getWalletsArr];
    
    [self requestTXHistory];
    
    if (self.walletArr.count == 1) {
        self.swithBtn.hidden = YES;
    }
    else{
        self.swithBtn.hidden = NO;
    }
}

- (void)requestTXHistory{
    //请求最新历史记录写入数据库
    [[ApexTransferHistoryManager shareManager] requestTxHistoryForAddress:self.model.address Success:^(CYLResponse *response) {

        [self.tableView.mj_header endRefreshing];
        [self requestSuccessLoadDataFromFMDB];
    } failure:^(NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [self showMessage:SOLocalizedStringFromTable(@"Request Failed, Please Check Your Network Status", nil)];
    }];
}

- (void)transferStatusHasChanged{
    [self requestSuccessLoadDataFromFMDB];
}

- (void)requestSuccessLoadDataFromFMDB{
    self.offset = 0;
    [self.tableView.mj_footer setState:MJRefreshStateIdle];
    self.contentArr = [[ApexTransferHistoryManager shareManager] getHistoriesOffset:self.offset walletAddress:self.model.address];
    if (self.contentArr.count == 0) {
        self.ev = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:SOLocalizedStringFromTable(@"Data Empty", nil) refreshBlock:nil];
    }else{
        [self.ev removeFromSuperview];
    }
    
    [self.tableView reloadData];
}

- (void)requestNextPage{
    self.offset += 1;
    NSArray *arr = [[ApexTransferHistoryManager shareManager] getHistoriesOffset:self.offset walletAddress:self.model.address];
    [self.contentArr addObjectsFromArray:arr];
    [self.tableView reloadData];
    
    if (arr.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
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
    
    [[[cell.pushBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApexTXDetailController *vc = [[ApexTXDetailController alloc] init];
        vc.model = self.contentArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    cell.model = self.contentArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    ApexTransferDetailHeader *h = [[ApexTransferDetailHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
//    return h;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}



#pragma mark - ------eventResponse------
- (void)handleEvent{
    @weakify(self);
    self.searchToolBar.textDidChangeSub = [RACSubject subject];
    [self.searchToolBar.textDidChangeSub subscribeNext:^(NSString *key) {
        
        if (key.length == 0) {
            //恢复拉动
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
            [self.tableView.mj_header setState:MJRefreshStateIdle];
            [self prepareData];
        }else{
            NSMutableArray *tempArr = [[ApexTransferHistoryManager shareManager] getHistoryiesWithPrefixOfTxid:key address:self.model.address];
            self.contentArr = tempArr;
            //禁用上拉下拉
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            [self.tableView.mj_header setState:MJRefreshStateNoMoreData];
            [self.tableView reloadData];
        }
    }];
    
    [[self.swithBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ApexChangeBindWalletController *vc = [[ApexChangeBindWalletController alloc] init];
        vc.transHistoryWalletModel = self.model;
        vc.didSelectCellSub = [RACSubject subject];
        [vc.didSelectCellSub subscribeNext:^(ApexWalletModel *x) {
            self.model = x;
            [self.searchToolBar clearEntrance];
            [self prepareData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
//        self.swithBtn.selected = !self.swithBtn.selected;
//        self.switchView.contentArr = self.walletArr;
//        [[UIApplication sharedApplication].keyWindow addSubview:self.switchView];
    }];
    
//    self.switchView.didSwitchSub = [RACSubject subject];
//    [self.switchView.didSwitchSub subscribeNext:^(ApexWalletModel *x) {
//        self.model = x;
//        [self.searchToolBar clearEntrance];
//        [self prepareData];
//    }];
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
        _searchToolBar.placeHolder = SOLocalizedStringFromTable(@"Search Txid", nil);
        [_searchToolBar setCancleBtnImage:[UIImage imageNamed:@"Group 5-1"]];
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
