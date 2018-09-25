//
//  ApexSendMoneyAmountCell.m
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSendMoneyAmountCell.h"

@implementation ApexSendMoneyAmountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.availableL];
        [self.contentView addSubview:self.sendNumTF];
        [self.contentView addSubview:self.allSendBtn];
        [self.contentView addSubview:self.unitL];
        
        [self.availableL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15.0f);
            make.top.equalTo(self.contentView).with.offset(15.0f);
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.height.mas_equalTo(15.0f);
        }];
        
        [self.sendNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.availableL.mas_bottom).with.offset(10.0f);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(kScreenW - 150.0f, 30.0f));
        }];
        
        [ApexUIHelper addLineInView:self.sendNumTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
        
        [self.allSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sendNumTF.mas_right);
            make.centerY.equalTo(self.sendNumTF);
            make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        }];
        
        [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.allSendBtn.mas_right);
            make.centerY.equalTo(self.sendNumTF);
            make.size.mas_equalTo(CGSizeMake(35.0f, 16.0f));
        }];
        
        [ApexUIHelper addLineInView:self.contentView color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 15, 0, 10)];
        
        [self handleEvent];
    }
    
    return self;
}

- (UILabel *)availableL
{
    if (!_availableL) {
        _availableL = [[UILabel alloc] init];
        _availableL.font = [UIFont systemFontOfSize:13];
    }
    
    return _availableL;
}

- (UITextField *)sendNumTF
{
    if (!_sendNumTF) {
        _sendNumTF = [[UITextField alloc] init];
        _sendNumTF.font = [UIFont systemFontOfSize:12];
        _sendNumTF.keyboardType = UIKeyboardTypeDecimalPad;
        _sendNumTF.placeholder = NSLocalizedString(@"Amount", nil);
    }
    
    return _sendNumTF;
}

- (UIButton *)allSendBtn
{
    if (!_allSendBtn) {
        _allSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allSendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_allSendBtn setTitleColor:[ApexUIHelper mainThemeColor] forState:UIControlStateNormal];
        [_allSendBtn setTitle:NSLocalizedString(@"allMoney", nil) forState:UIControlStateNormal];
    }
    
    return _allSendBtn;
}

- (void)handleEvent
{
    [[self.allSendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self routeEventWithName:RouteNameEvent_AmountCellDidClickSendMoney userInfo:@{}];
    }];
    
    [[self.sendNumTF rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self routeEventWithName:RouteNameEvent_AmountCellDidEditSendMoney userInfo:@{}];
    }];
}

- (UILabel *)unitL
{
    if (!_unitL) {
        _unitL = [[UILabel alloc] init];
        _unitL.font = [UIFont systemFontOfSize:13];
        _unitL.text = @"CPX";
    }
    
    return _unitL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
