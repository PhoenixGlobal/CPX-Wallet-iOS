//
//  ApexEncourageSubmitCell.m
//  Apex
//
//  Created by 冯志勇 on 2018/8/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexEncourageSubmitCell.h"

@implementation ApexEncourageSubmitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _inputTextField = [[ApexAlertTextField alloc] initWithFrame:CGRectZero];
        _inputTextField.font = [UIFont systemFontOfSize:13];
        _inputTextField.floatingLabelYPadding = 5;
        
        _inputTextField.floatingLabelTextColor = [UIColor colorWithHexString:@"555555"];
        _inputTextField.floatingLabelActiveTextColor = [ApexUIHelper mainThemeColor];
        
        _inputTextField.keepBaseline = YES;
        _inputTextField.isHiddenBottomLine = YES;
        _inputTextField.secureTextEntry = NO;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _inputTextField.alertString = SOLocalizedStringFromTable(@"Please enter the correct wallet address", nil);
        _inputTextField.alertShowConditionBlock = ^BOOL(NSString *text) {
             
             if (text.length > 0) {
                 return false;
             }
             return true;
         };
        
        [self.contentView addSubview:_inputTextField];
        [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20.0);
            make.right.equalTo(self.contentView).with.offset(-20.0f);
            make.top.equalTo(self.contentView).with.offset(5.0f);
            make.height.mas_equalTo(40.0f);
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
