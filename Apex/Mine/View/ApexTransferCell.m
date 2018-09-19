//
//  ApexTransferCell.m
//  Apex
//
//  Created by chinapex on 2018/5/29.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTransferCell.h"
#import <UIImageView+WebCache.h>

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
    
    
    !(model.assetId) ? (model.assetId = neo_assetid) : nil;
    
    if ([assetId_CPX containsString:model.assetId]) {
        self.iconImage.image = CPX_Logo;
    }else{
        
        if ([model.type isEqualToString:@"Eth"] || [model.type isEqualToString:@"Erc20"]) {
            
            for (ApexAssetModel *assetModel in [ETHAssetModelManage getLocalAssetModelsArr]) {
                if ([assetModel.hex_hash isEqualToString:model.assetId]) {
                    model.imageURL = assetModel.image_url;
                    break;
                }
            }
            
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:ETHPlaceHolder];
        }else{
            self.iconImage.image = NEOPlaceHolder;
        }
    }
    
    _timeStampL.hidden = YES;
    
    switch (model.status) {
        case ApexTransferStatus_Progressing:{
            _successFlag.text = SOLocalizedStringFromTable(@"Confirming", nil);
            _successFlag.textColor = [ApexUIHelper mainThemeColor];
        }
            break;
        case ApexTransferStatus_Failed:{
            _successFlag.text = SOLocalizedStringFromTable(@"Fail", nil);
            _successFlag.textColor = [UIColor redColor];
            _timeStampL.hidden = NO;
        }
            
            break;
        case ApexTransferStatus_Confirmed:{
            _successFlag.text = SOLocalizedStringFromTable(@"Success", nil);
            _successFlag.textColor = [UIColor colorWithHexString:@"54CA80"];
            _timeStampL.hidden = NO;
        }
            break;
        case ApexTransferStatus_Blocking:{
            _successFlag.text = SOLocalizedStringFromTable(@"Blocking", nil);
            _successFlag.textColor = [UIColor colorWithHexString:@"F5A623"];
        }
            break;
            
        default:
            break;
    }

    [self caculatePeriod];
}

- (void)caculatePeriod{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.time.doubleValue];
    _timeStampL.text = [NSString stringWithFormat:@"%ld-%ld-%ld %02ld:%02ld:%02ld",(long)date.year,date.month,date.day, date.hour, date.minute,date.second];
    
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
        _amountL.text = @"交易额()";
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
