//
//  ApexTransferCell.m
//  Apex
//
//  Created by chinapex on 2018/5/29.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTransferCell.h"

@implementation ApexTransferCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.toAddressL];
    [self addSubview:self.amountL];
    [self addSubview:self.timeStampL];
    
     [ApexUIHelper addLineInView:self color:UIColorHex(dddddd) edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    [self.amountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.toAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(scaleWidth375(25));
        make.right.equalTo(self.amountL.mas_left).offset(-35);
    }];
    
    
    [self.timeStampL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(scaleWidth375(-50));
    }];
}

- (void)setModel:(ApexTXRecorderModel *)model{
    _model = model;
    _toAddressL.text = model.toAddress;
    _amountL.text = model.value;
    [self caculatePeriod];
}

- (void)caculatePeriod{
    CGFloat timeStamp = self.model.timeStamp.floatValue;
    CGFloat now = [[NSDate date] timeIntervalSince1970];
    CGFloat period = now - timeStamp;
    if (period <= 60) {
        _timeStampL.text = [NSString stringWithFormat:@"%.0f秒前",period];
    }
    
    if (period > 60 && period < 3600) {
        _timeStampL.text = [NSString stringWithFormat:@"%.0f分钟前",period/60.0];
    }
    
    if (period > 3600 && period <= 86400) {
        _timeStampL.text = [NSString stringWithFormat:@"%.0f小时前",period/3600.0];
    }
    
    if (period > 86400) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        _timeStampL.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)date.year,date.month,date.day];
    }
    
}

#pragma mark - setter getter
- (UILabel *)toAddressL{
    if (!_toAddressL) {
        _toAddressL = [[UILabel alloc] init];
        _toAddressL.text = @"钱包地址";
        _toAddressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _toAddressL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _toAddressL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _toAddressL;
}

- (UILabel *)amountL{
    if (!_amountL) {
        _amountL = [[UILabel alloc] init];
        _amountL.text = @"交易额(CPX)";
        _amountL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _amountL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _amountL;
}

- (UILabel *)timeStampL{
    if (!_timeStampL) {
        _timeStampL = [[UILabel alloc] init];
        _timeStampL.text = @"0000";
        _timeStampL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _timeStampL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _timeStampL;
}

@end
