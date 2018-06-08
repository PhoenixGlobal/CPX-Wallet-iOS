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
#import "ApexDrawTransAnimator.h"
#import "ApexMorePanelController.h"

#define RouteNameEvent_ShowMorePanel @"RouteNameEvent_ShowMorePanel"

@interface ApexAssetMainController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) CYLEmptyView *emptyV;
@property (nonatomic, strong) ApexSearchWalletToolBar *searchTooBar;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) ApexDrawTransAnimator *transAnimator;
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
    
    self.navigationController.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ApexAssetMainViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.accessoryBaseView addSubview:self.searchTooBar];
    [self.searchTooBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchTooBar.superview);
    }];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    header.stateLabel.textColor = [ApexUIHelper grayColor240];
    header.lastUpdatedTimeLabel.textColor = [ApexUIHelper grayColor240];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)setNav{
    self.title = @"资产";
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
}

- (void)getWalletLists{
    [self.searchTooBar clearEntrance];
    _contentArr = [ApexWalletManager getWalletsArr];
    [self.tableView reloadData];
}

#pragma mark - ------transition-----
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        if ([toVC isKindOfClass:[ApexMorePanelController class]]) {
            return [CYLTansitionManager transitionObjectwithTransitionStyle:CYLTransitionStyle_Push animateDuration:0.3 andTransitionAnimation:self.transAnimator];
        }else{
            return nil;
        }
    }else {
        if ([fromVC isKindOfClass:[ApexMorePanelController class]]) {
            return [CYLTansitionManager transitionObjectwithTransitionStyle:CYLTransitionStyle_Pop animateDuration:0.3 andTransitionAnimation:self.transAnimator];
        }else{
            return nil;
        }
    }
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

- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if([eventName isEqualToString:RouteNameEvent_ShowMorePanel]){
        ApexMorePanelController *vc = [[ApexMorePanelController alloc] init];
        vc.funcConfigArr = @[@(PanelFuncConfig_Create), @(PanelFuncConfig_Import)];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - ------getter & setter------
- (ApexSearchWalletToolBar *)searchTooBar{
    if (!_searchTooBar) {
        _searchTooBar = [[ApexSearchWalletToolBar alloc] init];
    }
    return _searchTooBar;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.frame = CGRectMake(0, 0, 40, 40);
        [_moreBtn setImage:[UIImage imageNamed:@"dots"] forState:UIControlStateNormal];
        [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteNameEvent_ShowMorePanel userInfo:@{}];
        }];
    }
    return _moreBtn;
}

- (ApexDrawTransAnimator *)transAnimator{
    if (!_transAnimator) {
        _transAnimator = [[ApexDrawTransAnimator alloc] init];
    }
    return _transAnimator;
}
@end
