//
//  ApexSendMoneyToCell.m
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSendMoneyToCell.h"

@interface ApexSendMoneyToCell ()

@property (nonatomic, strong) UILabel *toLabel;
@property (nonatomic, strong) UITextField *walletAddressTF;

@end

@implementation ApexSendMoneyToCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.toLabel];
        [self.contentView addSubview:self.walletAddressTF];
        
        [self.toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15.0f);
            make.top.equalTo(self.contentView).with.offset(15.0f);
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.height.mas_equalTo(23.0f);
        }];
        
        [self.walletAddressTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.toLabel);
            make.top.equalTo(self.toLabel.mas_bottom).with.offset(5.0f);
            make.height.mas_equalTo(30.0f);
        }];
        
        [ApexUIHelper addLineInView:self.contentView color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 15, 0, 10)];
    }
    
    return self;
}

- (UILabel *)toLabel
{
    if (!_toLabel) {
        _toLabel = [[UILabel alloc] init];
        _toLabel.font = [UIFont systemFontOfSize:18];
        _toLabel.text = NSLocalizedString(@"To:", nil);
        _toLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    
    return _toLabel;
}

- (UITextField *)walletAddressTF
{
    if (!_walletAddressTF) {
        _walletAddressTF = [[UITextField alloc] init];
        _walletAddressTF.font = [UIFont systemFontOfSize:13];
        _walletAddressTF.textColor = [UIColor blackColor];
        _walletAddressTF.placeholder = NSLocalizedString(@"SendMoneyAddress", nil);
    }
    
    return _walletAddressTF;
}

- (void)setToAddressString:(NSString *)toAddressString
{
    _toAddressString = toAddressString;
    self.toLabel.text = toAddressString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
