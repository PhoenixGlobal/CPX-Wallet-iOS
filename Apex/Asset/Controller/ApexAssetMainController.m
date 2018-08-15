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
#import "ApexNoWalletView.h"

#define RouteNameEvent_ShowMorePanel @"RouteNameEvent_ShowMorePanel"

@interface ApexAssetMainController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) CYLEmptyView *emptyV;
@property (nonatomic, strong) ApexSearchWalletToolBar *searchTooBar;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) ApexDrawTransAnimator *transAnimator;
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) ApexNoWalletView *noWalletView; /**<  */
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
    [self setEdgeGesture];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    [self.emptyV removeFromSuperview];
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
    self.title = SOLocalizedStringFromTable(@"Assets", nil);
    
    self.navigationController.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
    [self.navigationController findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
}

- (void)getWalletLists{
    [self.searchTooBar clearEntrance];
    NSNumber *walletType = [TKFileManager ValueWithKey:KglobleWalletType];
    if (walletType.integerValue == ApexWalletType_Neo) {
        _contentArr = [ApexWalletManager getWalletsArr];
    }else{
        _contentArr = [ETHWalletManager getWalletsArr];
    }
    
    
    if (_contentArr.count == 0) {
        [self.baseView addSubview:self.noWalletView];
        [self.noWalletView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.baseView);
        }];
        self.noWalletView.hidden = NO;
    }else{
        self.noWalletView.hidden = YES;
    }
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
            [self.transAnimator clearRedundentView];
            return nil;
        }
    }
}

/**
 实现此方法后 所有的转场动画过程都要由ApexDrawTransPercentDriven的百分比决定*/
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    if (@available(iOS 11.0, *)) {
        //ios11 支持百分比驱动
        return [ApexDrawTransPercentDriven shareDriven];
    }else{
        return nil;
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
        
        NSArray *wallets = @[];
        if (GlobleWalletType == ApexWalletType_Neo) {
            wallets = [ApexWalletManager getWalletsArr];
        }else{
            wallets = [ETHWalletManager getWalletsArr];
        }
        
        if (key.length == 0) {
            self.contentArr = [wallets mutableCopy];
            [self.emptyV removeFromSuperview];
            self.emptyV = nil;
            [self.tableView reloadData];
            return;
        }
        
        [self.contentArr removeAllObjects];
        
        for (ApexWalletModel *wallet in wallets) {
            
            if ([wallet.address.lowercaseString containsString:key.lowercaseString]) {
                [self.contentArr addObject:wallet];
            }
        }
        
        if (self.contentArr.count == 0) {
            if (!self.emptyV) {
                self.emptyV = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:SOLocalizedStringFromTable(@"Data Empty", nil) refreshBlock:nil];
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
    vc.typeArr = @[@(ApexWalletType_Neo), @(ApexWalletType_Eth)];
    vc.didChangeTypeSub = [RACSubject subject];
    [vc.didChangeTypeSub subscribeNext:^(NSNumber *type) {
        [TKFileManager saveValue:type forKey:KglobleWalletType];
        [self getWalletLists];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - ------getter & setter------
- (ApexSearchWalletToolBar *)searchTooBar{
    if (!_searchTooBar) {
        _searchTooBar = [[ApexSearchWalletToolBar alloc] init];
        [_searchTooBar setTFBackColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_searchTooBar setCancleBtnImage:[UIImage imageNamed:@"Group 5-1"]];
    }
    return _searchTooBar;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.frame = CGRectMake(0, 0, 40, 40);
        [_moreBtn setImage:[UIImage imageNamed:@"Fill 1"] forState:UIControlStateNormal];
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

- (ApexNoWalletView *)noWalletView{
    if (!_noWalletView) {
        _noWalletView = [[ApexNoWalletView alloc] init];
        [_noWalletView setMessage:SOLocalizedStringFromTable(@"noWalletInAssets", nil)];
        [_noWalletView setBtnHidden:YES];
    }
    return _noWalletView;
}
@end
