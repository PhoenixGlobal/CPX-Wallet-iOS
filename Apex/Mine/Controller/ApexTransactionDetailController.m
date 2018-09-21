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
#import "ETHTransferHistoryManager.h"
#import "ApexCopyLable.h"

@interface ApexTransactionDetailController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong)  ApexCopyLable *addressL;
@property (nonatomic, strong) ApexSearchWalletToolBar *searchToolBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *swithBtn;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) CYLEmptyView *emptyView;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) id<ApexTransHistoryProtocal> historyManager; /**<  */
@end

@implementation ApexTransactionDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    [self handleEvent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TranferStatusHasChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_TranferHasConfirmed object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferStatusHasChanged) name:Notification_TranferStatusHasChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTXHistory) name:Notification_TranferHasConfirmed object:nil];
}

#pragma mark - ------private------
- (void)initUI{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.swithBtn];
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.addressL];
    [self.view addSubview:self.searchToolBar];
    [self.view addSubview:self.tableView];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo([ApexUIHelper naviBarHeight] + 70.0f);
    }];
    
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.lessThanOrEqualTo(self.view).with.offset(15.0f);
//        make.right.lessThanOrEqualTo(self.view).with.offset(-15.0f);
        make.top.equalTo(self.view).with.offset([ApexUIHelper naviBarHeight]);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.searchToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.addressL.mas_bottom).with.offset(10.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.tableView registerClass:[ApexTransferCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self requestTXHistory];
    }];
    [self.tableView.mj_header setAutomaticallyChangeAlpha:YES];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self requestNextPage];
    }];
    
    //获取本地信息
    [self requestSuccessLoadDataFromFMDB];
}

- (void)prepareData
{
    self.title = self.model.name;
    self.addressL.text = self.model.address;
    [self requestTXHistory];
}

- (void)requestTXHistory{
    //请求最新历史记录写入数据库
    [_historyManager requestTxHistoryForAddress:self.model.address Success:^(CYLResponse *response) {
        
        [self.tableView.mj_header endRefreshing];
        [self requestSuccessLoadDataFromFMDB];
    } failure:^(NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [self showMessage:SOLocalizedStringFromTable(@"Request Failed, Please Check Your Network Status", nil)];
    }];
}

- (void)transferStatusHasChanged
{
    [self requestSuccessLoadDataFromFMDB];
}

- (void)requestSuccessLoadDataFromFMDB{
    self.offset = 0;
    [self.tableView.mj_footer setState:MJRefreshStateIdle];
    self.contentArr = [_historyManager getHistoriesOffset:self.offset walletAddress:self.model.address];
    
    if (self.contentArr.count == 0) {
        [self showEmptyView];
    }else{
        [self clearEmptyView];
    }
    
    [self.tableView reloadData];
}

- (void)requestNextPage{
    self.offset += 1;
    NSArray *arr = [_historyManager getHistoriesOffset:self.offset walletAddress:self.model.address];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    @weakify(self);
    self.searchToolBar.textDidChangeSub = [RACSubject subject];
    [self.searchToolBar.textDidChangeSub subscribeNext:^(NSString *key) {
        @strongify(self);
        if (key.length == 0) {
            //恢复拉动
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
            [self.tableView.mj_header setState:MJRefreshStateIdle];
            [self prepareData];
        }else{
            NSMutableArray *tempArr = [self.historyManager getHistoryiesWithPrefixOfTxid:key address:self.model.address];
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
        vc.shouldIncludETH = YES;
        vc.didSelectCellSub = [RACSubject subject];
        [vc.didSelectCellSub subscribeNext:^(ApexWalletModel *x) {
            self.model = x;
            [self.searchToolBar clearEntrance];
            [self prepareData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

#pragma mark - ------getter & setter------
- (void)setModel:(ApexWalletModel *)model{
    _model = model;
    if ([model isKindOfClass:[ETHWalletModel class]]) {
        _historyManager = [ETHTransferHistoryManager shareManager];
    }else{
        _historyManager = [ApexTransferHistoryManager shareManager];
    }
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barImage"]];
    }
    return _backgroundImageView;
}

- (ApexCopyLable *)addressL
{
    if (!_addressL) {
        _addressL = [[ApexCopyLable alloc] init];
        _addressL.font = [UIFont systemFontOfSize:13];
        _addressL.textColor = [UIColor whiteColor];
        _addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _addressL.textAlignment = NSTextAlignmentCenter;
        _addressL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
            pastBoard.string = self.addressL.text;
            [self showMessage:SOLocalizedStringFromTable(@"CopySuccess", nil)];
        }];
        [_addressL addGestureRecognizer:tap];
    }
    
    return _addressL;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [ApexUIHelper naviBarHeight] + 70.0f, kScreenW, kScreenH - [ApexUIHelper naviBarHeight] - 70.0f) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 55.0f;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    
    return _tableView;
}

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
        _searchToolBar = [[ApexSearchWalletToolBar alloc] init];
        _searchToolBar.placeHolder = SOLocalizedStringFromTable(@"Search Txid", nil);
        [_searchToolBar setCancleBtnImage:[UIImage imageNamed:@"Group 5-1"]];
    }
    return _searchToolBar;
}

- (NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
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
