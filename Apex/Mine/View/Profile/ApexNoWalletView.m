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
    
    _imageV = [[UIImageView alloc] init];
    [self addSubview:_imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(70);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(330));
        make.height.mas_equalTo(scaleHeight667(280));
    }];
    
    _messageL = [[UILabel alloc] init];
    _messageL.text = SOLocalizedStringFromTable(@"noWallet", nil);
    _messageL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageL];
    [self.messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(20);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
    }];
}

@end
