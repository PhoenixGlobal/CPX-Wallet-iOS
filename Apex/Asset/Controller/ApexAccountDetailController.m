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
#import "ApexMorePanelController.h"
#import "ApexDrawTransAnimator.h"
#import "ApexAddAssetsController.h"

#define RouteNameEvent_ShowMorePanel @"RouteNameEvent_ShowMorePanel"

@interface ApexAccountDetailController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) ApexAccountStateModel *accountModel;
//@property (nonatomic, strong) CYLEmptyView *emptyV;
@property (nonatomic, strong) NSMutableArray *assetArr;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) ApexDrawTransAnimator *transAnimator;
@property (nonatomic, strong) NSMutableDictionary *assetMap; //资产对应的余额字典
@property (nonatomic, strong) UIImageView *backIV;
@end

@implementation ApexAccountDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
    [self requestAsset];
    [self setEdgeGesture];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)initUI{
    
    [self.view insertSubview:self.backIV atIndex:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ApexAssetCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.accessoryBaseView addSubview:self.addressL];
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.addressL.superview);
    }];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self requestAsset];
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
    self.navigationController.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
}

- (void)getLoacalAsset{
    self.title = self.walletModel.name;
    self.addressL.text = self.walletModel.address;
    self.assetArr = self.walletModel.assetArr;
    [ApexWalletManager reSortAssetArr:self.assetArr];
    [self creataAssetMap];
}

- (void)creataAssetMap{
    self.assetMap = [NSMutableDictionary dictionary];
    for (BalanceObject *balance in self.assetArr) {
        [self.assetMap setValue:balance.value forKey:balance.asset];
    }
}

- (void)requestAsset{
    
    [self getLoacalAsset];
    @weakify(self);
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [ApexWalletManager getAccountStateWithAddress:self.walletModel.address Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            @strongify(self);
            self.accountModel = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
            [subscriber sendNext:self.accountModel.balances];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
            [self showMessage:@"请求失败,请检查网络连接"];
        }];
        
        return nil;
    }];
    
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *nep5Keys = [self.assetMap.allKeys mutableCopy];
        [nep5Keys removeObject:assetId_NeoGas];
        [nep5Keys removeObject:assetId_Neo];
        
        for (NSString *assetId in nep5Keys) {
            if (![assetId isEqualToString:assetId_Neo] && ![assetId isEqualToString:assetId_NeoGas]) {
                //代币
                [ApexWalletManager getNep5AssetAccountStateWithAddress:self.walletModel.address andAssetId:assetId Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [array addObject:responseObject];
                    
                    if (array.count == nep5Keys.count) {
                        [subscriber sendNext:array];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [self showMessage:@"请求失败,请检查网络连接"];
                }];
            }
        }
        
        return nil;
    }];

    [self rac_liftSelector:@selector(updateWithR1:R2:) withSignals:request1,request2, nil];
}

- (void)updateWithR1:(id)r1 R2:(id)r2{
    [self.tableView.mj_header endRefreshing];
    //asset
    [self updateAssets:r1];
    //nep5
    [self updateAssets:r2];
    [self.tableView reloadData];
}

- (void)updateAssets:(NSArray*)balanceArr{
    
    if (balanceArr.count == 0) {
        //网络请求没有返回任何资产,本地资产置0
        for (BalanceObject *localObj in self.assetArr) {
            localObj.value = @"0.0";
        }
        
    }else{
        
        for (BalanceObject *remoteObj in balanceArr) {
            
            if ([self.assetMap.allKeys containsObject:remoteObj.asset]) {
                //更新余额
                BalanceObject *equalObj = nil;
                for (BalanceObject *localObj in [self.assetArr copy]) {
                    if ([localObj.asset isEqualToString:remoteObj.asset]) {
                        equalObj = localObj;
                        break;
                    }
                }
                if (equalObj) {
                    [self.assetArr removeObject:equalObj];
                    [self.assetArr addObject:remoteObj];
                }
            }else{
                //余额置0或者添加余额
                BalanceObject *equalObj = nil;
                for (BalanceObject *localObj in [self.assetArr copy]) {
                    if ([localObj.asset isEqualToString:remoteObj.asset]) {
                        equalObj = localObj;
                        break;
                    }
                }
                if (equalObj) {
                    equalObj.value = @"0.0";
                }else{
                    [self.assetArr addObject:remoteObj];
                }
            }
        
        }
    }
    //更新本地存储的钱包资产
    [ApexWalletManager updateWallet:self.walletModel WithAssetsArr:self.assetArr];
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
    vc.wallModel = self.walletModel;
    vc.balanceModel = self.assetArr[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if([eventName isEqualToString:RouteNameEvent_ShowMorePanel]){
        [self pushAction];
    }
}

- (void)addressCopy{
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    pastBoard.string = self.walletModel.address;
    [self showMessage:@"钱包地址已复制到剪切板"];
}

- (void)pushAction{
//    ApexAddAssetsController *addVC = [[ApexAddAssetsController alloc] init];
//    [self.navigationController presentViewController:addVC animated:YES completion:nil];
    
    ApexMorePanelController *vc = [[ApexMorePanelController alloc] init];
    vc.curWallet = self.walletModel;
    vc.walletsArr = [ApexWalletManager getWalletsArr];
    vc.walletsArr = [vc.walletsArr sortedArrayUsingComparator:^NSComparisonResult(ApexWalletModel *wallet1, ApexWalletModel *wallet2) {
        return wallet1.createTimeStamp.integerValue > wallet2.createTimeStamp.integerValue;
    }];
    vc.funcConfigArr = @[@(PanelFuncConfig_Create), @(PanelFuncConfig_Import)];
    vc.didChooseWalletSub = [RACSubject subject];
    [vc.didChooseWalletSub subscribeNext:^(ApexWalletModel *x) {
        self.walletModel = x;
        [self getLoacalAsset];
        [self requestAsset];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ------getter & setter------
- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc] init];
        _addressL.frame = CGRectMake(222,134,309,37);
        _addressL.textAlignment = NSTextAlignmentCenter;
        _addressL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _addressL.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        _addressL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [self addressCopy];
            
//            UIAlertController *alertVC = [[UIAlertController alloc] init];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self addressCopy];
//            }];
//
//            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [alertVC dismissViewControllerAnimated:YES completion:nil];
//            }];
//
//            [alertVC addAction:action];
//            [alertVC addAction:cancle];
//
//            [self.navigationController presentViewController:alertVC animated:YES completion:nil];
            
        }];
        [_addressL addGestureRecognizer:tap];
    }
    return _addressL;
}

//- (CYLEmptyView *)emptyV{
//    if (!_emptyV) {
//        _emptyV = [CYLEmptyView showEmptyViewOnView:self.tableView emptyType:CYLEmptyViewType_EmptyData message:@"暂无数据" refreshBlock:nil];
//    }
//    return _emptyV;
//}

- (NSMutableArray *)assetArr{
    if (!_assetArr) {
        _assetArr = [NSMutableArray array];
    }
    return _assetArr;
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
