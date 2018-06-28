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
    [self addSubview:self.txidL];
    [self addSubview:self.amountL];
    [self addSubview:self.timeStampL];
    [self addSubview:self.iconImage];
    [self addSubview:self.successFlag];
    [self addSubview:self.pushBtn];
    
     [ApexUIHelper addLineInView:self color:UIColorHex(dddddd) edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];

    [self.timeStampL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txidL.mas_bottom).offset(10);
        make.left.equalTo(self.txidL);
    }];
    
    [self.amountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.txidL.mas_centerY);
        make.right.equalTo(self).offset(-5);
    }];
    
    
    [self.txidL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.amountL.mas_left).offset(-70);
//        make.right.mas_greaterThanOrEqualTo(170);
    }];
    
    [self.successFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeStampL);
        make.right.equalTo(self.amountL);
    }];

    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setModel:(ApexTransferModel *)model{
    _model = model;
    _txidL.text = model.txid;
    _amountL.text = model.value;
    
//    if ([_model.vmstate containsString:@"FAULT"]) {
//        _model.status = ApexTransferStatus_Failed;
//    }else if ([_model.vmstate containsString:@""]){
//    }
    _timeStampL.hidden = YES;
    
    switch (model.status) {
        case ApexTransferStatus_Progressing:{
            _successFlag.text = @"交易确认中";
            _successFlag.textColor = [ApexUIHelper mainThemeColor];
        }
            break;
        case ApexTransferStatus_Failed:{
            _successFlag.text = @"交易失败";
            _successFlag.textColor = [UIColor redColor];
            _timeStampL.hidden = NO;
        }
            
            break;
        case ApexTransferStatus_Confirmed:{
            _successFlag.text = @"交易成功";
            _successFlag.textColor = [UIColor colorWithHexString:@"54CA80"];
            _timeStampL.hidden = NO;
        }
            break;
        case ApexTransferStatus_Blocking:{
            _successFlag.text = @"交易打包中";
            _successFlag.textColor = [UIColor colorWithHexString:@"F5A623"];
        }
            break;
            
        default:
            break;
    }
    
    [self caculatePeriod];
}

- (void)caculatePeriod{
    CGFloat timeStamp = self.model.time.floatValue;
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
- (UILabel *)txidL{
    if (!_txidL) {
        _txidL = [[UILabel alloc] init];
        _txidL.text = @"钱包地址";
        _txidL.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _txidL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _txidL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _txidL;
}

- (UILabel *)amountL{
    if (!_amountL) {
        _amountL = [[UILabel alloc] init];
        _amountL.text = @"交易额(CPX)";
        _amountL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _amountL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _amountL;
}

- (UILabel *)timeStampL{
    if (!_timeStampL) {
        _timeStampL = [[UILabel alloc] init];
        _timeStampL.text = @"0000";
        _timeStampL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _timeStampL.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    return _timeStampL;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = NEOPlaceHolder;
    }
    return _iconImage;
}

- (UILabel *)successFlag{
    if (!_successFlag) {
        _successFlag = [[UILabel alloc] init];
        _successFlag.font = [UIFont systemFontOfSize:10];
    }
    return _successFlag;
}

- (UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [[UIButton alloc] init];
    }
    return _pushBtn;
}
@end
