//
//  ApexAlertTextField.m
//  Apex
//
//  Created by chinapex on 2018/5/29.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexAlertTextField.h"

@interface ApexAlertTextField()
@property (nonatomic, strong) UILabel *alertLable;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation ApexAlertTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        [self observeShouldShowAlert];
    }
    return self;
}

- (void)setUI{
    self.bottomLine = [ApexUIHelper addLineInView:self color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
}

- (void)observeShouldShowAlert{
    [self addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textDidChanged:(UITextField*)textfield{
    if (self.alertShowConditionBlock) {
       self.isAlertShowing = self.alertShowConditionBlock(self.text);
        self.alertLable.hidden = !self.isAlertShowing;
        
        if (!self.isAlertShowing) {
            self.bottomLine.backgroundColor = [ApexUIHelper grayColor];
        }else{
            self.bottomLine.backgroundColor = [UIColor redColor];
        }
    }
}

#pragma mark - setter
- (void)setAlertString:(NSString *)alertString{
    _alertString = alertString;
    
    [self addSubview:self.alertLable];
    self.alertLable.text = alertString;
    
    [self alertLableUISet];
}

- (void)alertLableUISet{
    [self.alertLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(2);
        make.left.equalTo(self);
    }];
}

#pragma mark - getter
- (UILabel *)alertLable{
    if (!_alertLable) {
        _alertLable = [[UILabel alloc] init];
        _alertLable.font = [UIFont systemFontOfSize:11];
        _alertLable.textColor = [UIColor redColor];
        _alertLable.textAlignment = NSTextAlignmentCenter;
        _alertLable.hidden = YES;
    }
    return _alertLable;
}

@end
