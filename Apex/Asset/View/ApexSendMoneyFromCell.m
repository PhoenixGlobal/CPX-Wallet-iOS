//
//  ApexSendMoneyFromCell.m
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSendMoneyFromCell.h"

@interface ApexSendMoneyFromCell ()

@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *walletnameLabel;
@property (nonatomic, strong) UILabel *walletAddressLabel;

@end

@implementation ApexSendMoneyFromCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.fromLabel];
        [self.contentView addSubview:self.walletnameLabel];
        [self.contentView addSubview:self.walletAddressLabel];
        
        [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15.0f);
            make.top.equalTo(self.contentView).with.offset(10.0f);
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.height.mas_equalTo(23.0f);
        }];
        
        [self.walletnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.fromLabel);
            make.top.equalTo(self.fromLabel.mas_bottom).with.offset(10.0f);
            make.height.mas_equalTo(20.0f);
        }];
        
        [self.walletAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.fromLabel);
            make.top.equalTo(self.walletnameLabel.mas_bottom).with.offset(5.0f);
            make.height.mas_equalTo(15.0f);
        }];
        
        [ApexUIHelper addLineInView:self.contentView color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 15, 0, 10)];
    }
    
    return self;
}

- (UILabel *)fromLabel
{
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.font = [UIFont systemFontOfSize:18];
        _fromLabel.text = NSLocalizedString(@"From:", nil);
        _fromLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    
    return _fromLabel;
}

- (UILabel *)walletnameLabel
{
    if (!_walletnameLabel) {
        _walletnameLabel = [[UILabel alloc] init];
        _walletnameLabel.font = [UIFont systemFontOfSize:17];
        _walletnameLabel.textColor = [UIColor blackColor];
    }
    
    return _walletnameLabel;
}

- (UILabel *)walletAddressLabel
{
    if (!_walletAddressLabel) {
        _walletAddressLabel = [[UILabel alloc] init];
        _walletAddressLabel.font = [UIFont systemFontOfSize:13];
        _walletAddressLabel.textColor = [UIColor blackColor];
        _walletAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    return _walletAddressLabel;
}

- (void)setWalletNameStr:(NSString *)walletNameStr{
    _walletNameStr = walletNameStr;
    self.walletnameLabel.text = walletNameStr;
}

- (void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    self.walletAddressLabel.text = addressStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
