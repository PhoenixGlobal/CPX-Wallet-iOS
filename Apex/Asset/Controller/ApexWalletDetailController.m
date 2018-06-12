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

#define RouteNameEvent_SendMoney @"RouteNameEvent_SendMoney"
#define RouteNameEvent_RequestMoney @"RouteNameEvent_RequestMoney"
#define RouteNameEvent_ShowMorePanel @"RouteNameEvent_ShowMorePanel"

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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController lt_setBackgroundColor:[ApexUIHelper navColor]];
}

#pragma mark - ------private------
- (void)setNav{
    self.navigationItem.titleView = self.titleL;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
    self.navigationController.delegate = self;
}

- (void)setUI{
    self.view.backgroundColor = [ApexUIHelper grayColor240];
    self.title = @"收款";
    
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.balanceL];
    [self.view addSubview:self.unitL];
//    [self.view addSubview:self.addressL];
    [self.view addSubview:self.requestBtn];
    [self.view addSubview:self.sendBtn];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(scaleHeight667(NavBarHeight+80));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35);
        make.top.equalTo(self.backIV.mas_bottom).offset(20);
        make.width.mas_equalTo(scaleWidth375(150));
        make.height.mas_equalTo(40);
    }];
    
    [self.requestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-35);
        make.top.width.height.equalTo(self.sendBtn);
    }];
    
    [self.balanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(70);
        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.mas_equalTo(scaleWidth375(50));
//        make.height.mas_equalTo(scaleHeight667(60));
    }];
    
    [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.balanceL);
        make.left.equalTo(self.balanceL.mas_right).offset(20);
    }];
    
//    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.balanceL.mas_bottom).offset(10);
//        make.centerX.equalTo(self.view.mas_centerX);
//    }];
    
    self.balanceL.text = self.balanceModel.value;
    
    NSString *assetName = @"err";
    if ([self.balanceModel.asset isEqualToString:assetId_CPX]) {
        assetName = @"CPX";
    }else if ([self.balanceModel.asset isEqualToString:assetId_Neo]){
        assetName = @"NEO";
    }else if ([self.balanceModel.asset isEqualToString:assetId_NeoGas]){
        assetName = @"GAS";
    }
    self.unitL.text = assetName;
}

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
        [self.navigationController pushViewController:svc animated:YES];
    }else if([eventName isEqualToString:RouteNameEvent_ShowMorePanel]){
        ApexMorePanelController *vc = [[ApexMorePanelController alloc] init];
        vc.curWallet = self.wallModel;
        vc.balanceModel = self.balanceModel;
        vc.funcConfigArr = @[@(PanelFuncConfig_Scan), @(PanelFuncConfig_Create), @(PanelFuncConfig_Import)];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    }else if ([eventName isEqualToString:RouteNameEvent_PanelViewScan]){
//        [self scanAction];
//    }else if ([eventName isEqualToString:RouteNameEvent_PanelViewCreatWallet]){
//        ApexCreatWalletController *wvc = [[ApexCreatWalletController alloc] init];
//        [self.navigationController pushViewController:wvc animated:YES];
//    }
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

#pragma mark - ------getter & setter------
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
        _backIV.image = [UIImage imageNamed:@"Background"];
    }
    return _backIV;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"转账" forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [ApexUIHelper mainThemeColor];
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
        [_requestBtn setTitle:@"收款" forState:UIControlStateNormal];
        _requestBtn.backgroundColor = [ApexUIHelper mainThemeColor];
        _requestBtn.layer.cornerRadius = 6;
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

@end
