//
//  ApexTransferDetailHeader.m
//  Apex
//
//  Created by chinapex on 2018/5/29.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTransferDetailHeader.h"

@implementation ApexTransferDetailHeader
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    [ApexUIHelper addLineInView:self color:UIColorHex(dddddd) edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    [self addSubview:self.toAddressL];
    [self addSubview:self.amountL];
    [self addSubview:self.timeStampL];
    
    [self.toAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(scaleWidth375(25));
    }];
    
    [self.amountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.toAddressL.mas_right).offset(scaleWidth375(84));
    }];
    
    [self.timeStampL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(scaleWidth375(-50));
    }];
}


#pragma mark - setter getter
- (UILabel *)toAddressL{
    if (!_toAddressL) {
        _toAddressL = [[UILabel alloc] init];
        _toAddressL.text = @"转账地址";
        _toAddressL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _toAddressL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _toAddressL;
}

- (UILabel *)amountL{
    if (!_amountL) {
        _amountL = [[UILabel alloc] init];
        _amountL.text = @"交易额";
        _amountL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _amountL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _amountL;
}

- (UILabel *)timeStampL{
    if (!_timeStampL) {
        _timeStampL = [[UILabel alloc] init];
        _timeStampL.text = @"交易时间";
        _timeStampL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _timeStampL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _timeStampL;
}

@end
