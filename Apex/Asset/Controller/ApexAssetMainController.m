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
@property (nonatomic, strong) UIImageView *backIV;
@end

@implementation ApexAssetMainController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self handleEvent];
//    [ApexWalletManager getTransactionHistoryWithAddress:@"AQVh2pG732YvtNaxEGkQUei3YA4cvo7d2i" BeginTime:0 Success:^(CYLResponse *response) {
//        NSLog(@"%@",response.returnObj);
//    } failure:^(NSError *error) {
//        NSLog(@"");
//    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getWalletLists];
    [self setNav];
    [self setEdgeGesture];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.emptyV removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}
#pragma mark - ------private------
- (void)initUI{
//    self.view.backgroundColor = self.baseColor;
    [self.view insertSubview:self.backIV atIndex:0];
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

- (void)setEdgeGesture{
    [[ApexDrawTransPercentDriven shareDriven] setPercentDrivenForFromViewController:self edgePan:^(UIScreenEdgePanGestureRecognizer *edgePan) {
        switch (edgePan.state) {
            case UIGestureRecognizerStateBegan:
            {
                [self pushAction];
            }
                break;
            default:
                break;
        }
    }];
}


- (void)setNav{
    self.title = @"资产";
    self.navigationController.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
    [self.navigationController findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
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
            return [CYLTansitionManager transitionObjectwithTransitionStyle:CYLTransitionStyle_Push animateDuration:0.5 andTransitionAnimation:self.transAnimator];
        }else{
            return nil;
        }
    }else {
        if ([fromVC isKindOfClass:[ApexMorePanelController class]]) {
            return [CYLTansitionManager transitionObjectwithTransitionStyle:CYLTransitionStyle_Pop animateDuration:0.5 andTransitionAnimation:self.transAnimator];
        }else{
            return nil;
        }
    }
}

/**
 实现此方法后 所有的转场动画过程都要由ApexDrawTransPercentDriven的百分比决定*/
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    return [ApexDrawTransPercentDriven shareDriven];
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
            
            if ([wallet.address.lowercaseString containsString:key.lowercaseString]) {
                [self.contentArr addObject:wallet];
            }
        }
        
        if (self.contentArr.count == 0) {
            if (!self.emptyV) {
                self.emptyV = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:@"暂无数据" refreshBlock:nil];
            }
            [self.tableView addSubview:self.emptyV];
        }else{
            [self.emptyV removeFromSuperview];
            self.emptyV = nil;
        }
        [self.tableView reloadData];
        
    }];
}

- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if([eventName isEqualToString:RouteNameEvent_ShowMorePanel]){
        [self pushAction];
    }
}

- (void)pushAction{
    ApexMorePanelController *vc = [[ApexMorePanelController alloc] init];
    vc.funcConfigArr = @[@(PanelFuncConfig_Create), @(PanelFuncConfig_Import)];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
//        _transAnimator.fakeView = [self.view snapshotViewAfterScreenUpdates:NO];
    }
    return _transAnimator;
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backIV.image = [UIImage imageNamed:@"backImage"];
    }
    return _backIV;
}
@end
