//
//  ApexNoWalletView.m
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexNoWalletView.h"

@interface ApexNoWalletView()
@property (nonatomic, strong) UIImageView *imageV; /**<*/
@property (nonatomic, strong) UILabel *messageL; /**<  */
@property (nonatomic, strong) UIButton *toCreateWalletBtn; /**<  */
@end

@implementation ApexNoWalletView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyWallet"]];
    [self addSubview:_imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(70);
        make.centerX.equalTo(self.mas_centerX);
        make.height.width.mas_equalTo(scaleWidth375(270));
//        make.height.mas_equalTo(scaleHeight667(280));
    }];
    
    _messageL = [[UILabel alloc] init];
    _messageL.text = SOLocalizedStringFromTable(@"noWallet", nil);
    _messageL.textAlignment = NSTextAlignmentCenter;
    _messageL.numberOfLines = 0;
    [_messageL setTextColor:[UIColor colorWithHexString:@"666666"]];
    [self addSubview:_messageL];
    [self.messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(20);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
    }];
    
    _toCreateWalletBtn = [[UIButton alloc] init];
    [self addSubview:_toCreateWalletBtn];
    [_toCreateWalletBtn setTitle:SOLocalizedStringFromTable(@"Create Wallet", nil) forState:UIControlStateNormal];
    _toCreateWalletBtn.backgroundColor = [ApexUIHelper mainThemeColor];
    [self.toCreateWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(40);
    }];
    [[_toCreateWalletBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self routeEventWithName:RouteEventName_NoWalletViewToCreateWallet userInfo:@{}];
    }];
}

- (void)setMessage:(NSString *)message{
    if (message.length !=0) {
        self.messageL.text = message;
    }
}

- (void)setBtnHidden:(BOOL)isHidden{
    self.toCreateWalletBtn.hidden = isHidden;
}
@end
