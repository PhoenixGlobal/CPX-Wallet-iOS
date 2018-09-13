//
//  ApexWalletDetailController.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWalletDetailController.h"
#import "ApexAccountStateModel.h"
#import "ApexRequestMoenyController.h"
#import "ApexSendMoneyController.h"
#import "ApexCreatWalletController.h"
#import "ApexTempEmptyView.h"
#import "ApexMorePanelController.h"
#import "ApexDrawTransAnimator.h"
#import "ApexScanAction.h"

#define RouteNameEvent_SendMoney @"RouteNameEvent_SendMoney"
#define RouteNameEvent_RequestMoney @"RouteNameEvent_RequestMoney"
#define RouteNameEvent_ScanAction @"RouteNameEvent_ScanAction"

@interface ApexWalletDetailController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *balanceL;
@property (nonatomic, strong) UILabel *unitL;
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *requestBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) ApexDrawTransAnimator *transAnimator;
@property (nonatomic, strong) id<ApexWalletManagerProtocal> walletManager; /**<  */
@property (nonatomic, assign) ApexWalletType type; /**<  */
@end

@implementation ApexWalletDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
//    [self setEdgeGesture];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)setNav{
    self.navigationItem.titleView = self.titleL;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
}

- (void)setUI{
    self.view.backgroundColor = [ApexUIHelper grayColor240];
    self.title = @"收款";
    
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.balanceL];
    [self.view addSubview:self.unitL];
    [self.view addSubview:self.requestBtn];
    [self.view addSubview:self.sendBtn];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(scaleHeight667(NavBarHeight+160));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.backIV.mas_bottom).offset(20);
        make.height.mas_equalTo(45);
    }];
    
    [self.requestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.width.height.equalTo(self.sendBtn);
        make.top.equalTo(self.sendBtn.mas_bottom).offset(15);
    }];
    
    [self.balanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50+NavBarHeight);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.greaterThanOrEqualTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-60);
    }];
    
    [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceL.mas_bottom).offset(0);
        make.centerX.equalTo(self.balanceL.mas_centerX);
    }];
    
//    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.balanceL.mas_bottom).offset(10);
//        make.centerX.equalTo(self.view.mas_centerX);
//    }];
    
    self.balanceL.text = self.balanceModel.value;
    NSMutableArray *arr = [NSMutableArray array];
    if (_type == ApexWalletType_Neo) {
        arr = [ApexAssetModelManage getLocalAssetModelsArr];
    }else{
        arr = [ETHAssetModelManage getLocalAssetModelsArr];
        NSString *assetName = @"ETH";
        self.unitL.text = assetName;
    }
    for (ApexAssetModel *model in arr) {
        if ([model.hex_hash containsString:self.balanceModel.asset]) {
            NSString *assetName = model.symbol;
            self.unitL.text = assetName;
            break;
        }
    }
}

//- (void)setEdgeGesture{
//    [[ApexDrawTransPercentDriven shareDriven] setPercentDrivenForFromViewController:self edgePan:^(UIScreenEdgePanGestureRecognizer *edgePan) {
//        switch (edgePan.state) {
//            case UIGestureRecognizerStateBegan:
//            {
//                [self pushAction];
//            }
//                break;
//            default:
//                break;
//        }
//    }];
//}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------


#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_RequestMoney]) {
        ApexRequestMoenyController *rvc = [[ApexRequestMoenyController alloc] init];
        rvc.walletAddress = self.wallModel.address;
        rvc.walletName = self.wallModel.name;
        [self.navigationController pushViewController:rvc animated:YES];
        
    }else if ([eventName isEqualToString:RouteNameEvent_SendMoney]){
        ApexSendMoneyController *svc = [[ApexSendMoneyController alloc] init];
        svc.walletAddress = self.wallModel.address;
        svc.walletName = self.wallModel.name;
        svc.unit = self.unitL.text;
        svc.balanceModel = self.balanceModel;
        svc.walletManager = self.walletManager;
        if ([_walletManager getWalletTransferStatusForAddress:self.wallModel.address]) {
            [self.navigationController pushViewController:svc animated:YES];
        }else{
            [self showMessage:SOLocalizedStringFromTable(@"ProcessingTrans", nil)];
        }
    }else if([eventName isEqualToString:RouteNameEvent_ScanAction]){
        [ApexScanAction shareScanHelper].curWallet = self.wallModel;
        [ApexScanAction shareScanHelper].balanceMode = self.balanceModel;
        [ApexScanAction shareScanHelper].type = self.type;
        if ([_walletManager getWalletTransferStatusForAddress:self.wallModel.address]) {
            [ApexScanAction scanActionOnViewController:self];
        }else{
            [self showMessage:SOLocalizedStringFromTable(@"ProcessingTrans", nil)];
        }
    }
}

//- (void)pushAction{
//    ApexMorePanelController *vc = [[ApexMorePanelController alloc] init];
//    vc.curWallet = self.wallModel;
//    vc.balanceModel = self.balanceModel;
//    vc.funcConfigArr = @[@(PanelFuncConfig_Scan), @(PanelFuncConfig_Create), @(PanelFuncConfig_Import)];
//    [self.navigationController pushViewController:vc animated:YES];
//}


#pragma mark - ------transition-----
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
//    if (operation == UINavigationControllerOperationPush) {
//        if ([toVC isKindOfClass:[ApexMorePanelController class]]) {
//            return [CYLTansitionManager transitionObjectwithTransitionStyle:CYLTransitionStyle_Push animateDuration:0.5 andTransitionAnimation:self.transAnimator];
//        }else{
//            return nil;
//        }
//    }else {
//        if ([fromVC isKindOfClass:[ApexMorePanelController class]]) {
//            return [CYLTansitionManager transitionObjectwithTransitionStyle:CYLTransitionStyle_Pop animateDuration:0.5 andTransitionAnimation:self.transAnimator];
//        }else{
//            return nil;
//        }
//    }
//}
//
///**
// 实现此方法后 所有的转场动画过程都要由ApexDrawTransPercentDriven的百分比决定*/
//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
//
//    return [ApexDrawTransPercentDriven shareDriven];
//}

#pragma mark - ------getter & setter------
- (void)setWallModel:(ApexWalletModel *)wallModel{
    _wallModel = wallModel;
    
    if ([wallModel isKindOfClass:ETHWalletModel.class]) {
        _walletManager = [ETHWalletManager shareManager];
        _type = ApexWalletType_Eth;
    }else{
        _type = ApexWalletType_Neo;
        _walletManager = [ApexWalletManager shareManager];
    }
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.frame = CGRectMake(152, 30, 72.5, 25);
        _titleL.text = self.wallModel.name;
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _titleL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _titleL;
}

- (UILabel *)balanceL{
    if (!_balanceL) {
        _balanceL = [[UILabel alloc] init];
        _balanceL.text = @"0";
        _balanceL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:50];
        _balanceL.textAlignment = NSTextAlignmentCenter;
        [_balanceL setAdjustsFontSizeToFitWidth:YES];
        _balanceL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _balanceL;
}

- (UILabel *)unitL{
    if (!_unitL) {
        _unitL = [[UILabel alloc] init];
        _unitL.text = @"Neo";
        _unitL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _unitL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _unitL;
}

- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc] init];
        _addressL.text = self.wallModel.address;
        _addressL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _addressL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _addressL;
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] init];
        _backIV.image = [UIImage imageNamed:@"barImage"];
    }
    return _backIV;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:SOLocalizedStringFromTable(@"Transfer", nil) forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        
        _sendBtn.backgroundColor = [ApexUIHelper mainThemeColor];
        _sendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _sendBtn.layer.borderWidth = 1.0/kScale;
        _sendBtn.layer.cornerRadius = 6;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [[_sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteNameEvent_SendMoney userInfo:@{}];
        }];
    }
    return _sendBtn;
}

- (UIButton *)requestBtn{
    if (!_requestBtn) {
        _requestBtn = [[UIButton alloc] init];
        [_requestBtn setTitleColor:[ApexUIHelper mainThemeColor] forState:UIControlStateNormal];
        [_requestBtn setTitle:SOLocalizedStringFromTable(@"Receipt", nil) forState:UIControlStateNormal];
        _requestBtn.backgroundColor = [UIColor whiteColor];
        _requestBtn.layer.cornerRadius = 6;
        _requestBtn.layer.borderColor = [ApexUIHelper mainThemeColor].CGColor;
        _requestBtn.layer.borderWidth = 1.0 / kScale;
        _requestBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [[_requestBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteNameEvent_RequestMoney userInfo:@{}];
        }];
    }
    return _requestBtn;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.frame = CGRectMake(0, 0, 40, 40);
        [_moreBtn setImage:[UIImage imageNamed:@"Group 3-3"] forState:UIControlStateNormal];
        [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteNameEvent_ScanAction userInfo:@{}];
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

@end
