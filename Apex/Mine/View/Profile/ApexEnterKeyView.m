//
//  ApexEnterKeyView.m
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexEnterKeyView.h"

@interface ApexEnterKeyView()
@property (nonatomic, strong) UITextField *keyTF; /**<  */
@property (nonatomic, strong) UIButton *confirmBtn; /**<  */
@property (nonatomic, strong) UILabel *titleL; /**<  */
@end

@implementation ApexEnterKeyView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self handleEvent];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleL];
    [self addSubview:self.keyTF];
    [self addSubview:self.confirmBtn];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(80);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.keyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom).offset(20);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-30);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(40);
    }];
}

- (void)handleEvent{
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self removeFromSuperview];
    }];
}

#pragma mark - getter setter
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = [UIColor blackColor];
        _titleL.text = SOLocalizedStringFromTable(@"enterPK", nil);
        _titleL.font = [UIFont systemFontOfSize:13];
    }
    return _titleL;
}

- (UITextField *)keyTF{
    if (!_keyTF) {
        _keyTF = [[UITextField alloc] init];
        _keyTF.borderStyle = UITextBorderStyleNone;
        [_keyTF addLinecolor:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
        _keyTF.font = [UIFont systemFontOfSize:13];
        _keyTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _keyTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _keyTF;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:SOLocalizedStringFromTable(@"Confirm", nil) forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = [ApexUIHelper mainThemeColor];
        _confirmBtn.layer.cornerRadius = 6;
    }
    return _confirmBtn;
}

@end
