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
#import "ApexMorePanelView.h"
#import "LXDScanCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "ApexCreatWalletController.h"

#define RouteNameEvent_SendMoney @"RouteNameEvent_SendMoney"
#define RouteNameEvent_RequestMoney @"RouteNameEvent_RequestMoney"
#define RouteNameEvent_ShowMorePanel @"RouteNameEvent_ShowMorePanel"

@interface ApexWalletDetailController ()<LXDScanCodeControllerDelegate>
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *balanceL;
@property (nonatomic, strong) UILabel *unitL;
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *requestBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) ApexMorePanelView *moreView;
@end

@implementation ApexWalletDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setNav];
}

#pragma mark - ------private------
- (void)setNav{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = self.titleL;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreBtn];
}

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"收款";
    
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.balanceL];
    [self.view addSubview:self.unitL];
    [self.view addSubview:self.addressL];
    [self.view addSubview:self.requestBtn];
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.moreView];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(scaleHeight667(192));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35);
        make.top.equalTo(self.backIV.mas_bottom).offset(10);
        make.width.mas_equalTo(scaleWidth375(150));
        make.height.mas_equalTo(scaleHeight667(40));
    }];
    
    [self.requestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-35);
        make.top.width.height.equalTo(self.sendBtn);
    }];
    
    [self.balanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(70);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(50));
        make.height.mas_equalTo(scaleHeight667(60));
    }];
    
    [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.balanceL);
        make.left.equalTo(self.balanceL.mas_right).offset(20);
    }];
    
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceL.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self.view);
    }];
    
    self.moreView.transform = CGAffineTransformMakeTranslation(-kScreenW, 0);
    
    self.balanceL.text = self.accountModel.balances.count == 0 ? @"0" : (self.accountModel.balances.firstObject.value);
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo{
    
    if (![codeInfo containsString:commonScheme]) {
        [self showMessage:@"未识别的二维码"];
        return;
    }
    
    ApexSendMoneyController *svc = [[ApexSendMoneyController alloc] init];
    svc.walletAddress = self.walletAddress;
    svc.walletName = self.walletName;
    svc.toAddressIfHave = [codeInfo stringByReplacingOccurrencesOfString:commonScheme withString:@""];
    [self.navigationController pushViewController:svc animated:YES];
}


#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_RequestMoney]) {
        ApexRequestMoenyController *rvc = [[ApexRequestMoenyController alloc] init];
        rvc.walletAddress = self.walletAddress;
        rvc.walletName = self.walletName;
        [self.navigationController pushViewController:rvc animated:YES];
    }else if ([eventName isEqualToString:RouteNameEvent_SendMoney]){
        ApexSendMoneyController *svc = [[ApexSendMoneyController alloc] init];
        svc.walletAddress = self.walletAddress;
        svc.walletName = self.walletName;
        [self.navigationController pushViewController:svc animated:YES];
    }else if([eventName isEqualToString:RouteNameEvent_ShowMorePanel]){
        _moreView.hidden = NO;
        _moreView.transform = CGAffineTransformIdentity;
    }else if ([eventName isEqualToString:RouteNameEvent_PanelViewScan]){
        [self scanAction];
    }else if ([eventName isEqualToString:RouteNameEvent_PanelViewCreatWallet]){
        ApexCreatWalletController *wvc = [[ApexCreatWalletController alloc] init];
        [self.navigationController pushViewController:wvc animated:YES];
    }
}


//二维码扫描
- (void)scanAction{
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有相机访问权限" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“”打开相机访问权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    LXDScanCodeController * scanCodeController = [LXDScanCodeController scanCodeController];
    scanCodeController.hidesBottomBarWhenPushed = YES;
    scanCodeController.scanDelegate = self;
    [self.navigationController pushViewController:scanCodeController animated:YES];
}

#pragma mark - ------getter & setter------
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.frame = CGRectMake(152, 30, 72.5, 25);
        _titleL.text = self.walletName;
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
        _addressL.text = self.walletAddress;
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

- (ApexMorePanelView *)moreView{
    if (!_moreView) {
        _moreView = [[ApexMorePanelView alloc] init];
        _moreView.hidden = YES;
        _moreView.nameL.text = self.walletName;
    }
    return _moreView;
}

@end
