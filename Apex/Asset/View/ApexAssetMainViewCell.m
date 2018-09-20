//
//  ApexAssetMainViewCell.m
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexAssetMainViewCell.h"

@interface ApexAssetMainViewCell()
@property (nonatomic, strong) UILabel *walletName;
@property (nonatomic, strong) UILabel *address;

@property (nonatomic, strong) ApexAccountStateModel *accountModel;
@end

@implementation ApexAssetMainViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        self.layer.borderWidth = 1.0/kScale;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrows-1_minimal-left"]];
        
        [self.contentView addSubview:self.walletName];
        [self.contentView addSubview:self.address];
        
        [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15.0f);
            make.top.equalTo(self.contentView).with.offset(20.0f);
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.height.mas_equalTo(23.0f);
        }];
        
        [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.walletName);
            make.bottom.equalTo(self.contentView).with.offset(-20.0f);
            make.height.mas_equalTo(16.0f);
        }];
    }
    
    return self;
}

- (UILabel *)walletName
{
    if (!_walletName) {
        _walletName = [[UILabel alloc] init];
        _walletName.font = [UIFont systemFontOfSize:19];
        _walletName.textColor = [UIColor blackColor];
    }
    
    return _walletName;
}

- (UILabel *)address
{
    if (!_address) {
        _address = [[UILabel alloc] init];
        _address.font = [UIFont systemFontOfSize:13];
        _address.textColor = [UIColor blackColor];
        _address.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    return _address;
}

- (void)setWalletNameStr:(NSString *)walletNameStr{
    _walletNameStr = walletNameStr;
    self.walletName.text = walletNameStr;
}

- (void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    self.address.text = addressStr;
}

@end
