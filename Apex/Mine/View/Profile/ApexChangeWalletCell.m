//
//  ApexChangeWalletCell.m
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexChangeWalletCell.h"
#import "ApexWalletModel.h"
@interface ApexChangeWalletCell()

@property (nonatomic, strong) UILabel *walletNameL;
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UIImageView *iconIV;

@end

@implementation ApexChangeWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addLinecolor:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
        
        [self.contentView addSubview:self.iconIV];
        [self.contentView addSubview:self.walletNameL];
        [self.contentView addSubview:self.addressL];
        [self.contentView addSubview:self.indicator];
        
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15.0f);
            make.top.equalTo(self.contentView).with.offset(10.0f);
            make.size.mas_equalTo(CGSizeMake(35.0f, 35.0f));
        }];
        
        [self.walletNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(60.0f);
            make.top.equalTo(self.contentView).with.offset(10.0f);
            make.right.equalTo(self.contentView).with.offset(-25.0f);
            make.height.mas_equalTo(15.0f);
        }];
        
        [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(60.0f);
            make.bottom.equalTo(self.contentView).with.offset(-10.0f);
            make.right.equalTo(self.contentView).with.offset(-25.0f);
            make.height.mas_equalTo(15.0f);
        }];
        
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(15.0f, 15.0f));
        }];
    }
    
    return self;
}

- (UIImageView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIImageView alloc] init];
        _indicator.image = [UIImage imageNamed:@"select"];
    }
    
    return _indicator;
}

- (UIImageView *)iconIV
{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] init];
    }
    
    return _iconIV;
}

- (UILabel *)walletNameL
{
    if (!_walletNameL) {
        _walletNameL = [[UILabel alloc] init];
        _walletNameL.font = [UIFont systemFontOfSize:13];
        _walletNameL.textColor = [UIColor blackColor];
    }
    
    return _walletNameL;
}

- (UILabel *)addressL
{
    if (!_addressL) {
        _addressL = [[UILabel alloc] init];
        _addressL.font = [UIFont systemFontOfSize:11];
        _addressL.textColor = [UIColor lightGrayColor];
        _addressL.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    return _addressL;
}

- (void)setModel:(ApexWalletModel *)model{
    _model = model;
    _walletNameL.text = model.name;
    _addressL.text = model.address;
    
    if ([model isKindOfClass:ETHWalletModel.class]) {
        _iconIV.image = ETHPlaceHolder;
    }else{
        _iconIV.image = NEOPlaceHolder;
    }
}

@end
