//
//  ApexSwitchHeaderBar.m
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexSwitchHeaderBar.h"

@interface ApexSwitchHeaderBar()
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation ApexSwitchHeaderBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self initUI];
}

#pragma mark - private
- (void)initUI{
    
    self.backgroundColor = [ApexUIHelper subThemeColor];
    
    _leftBtn = [[UIButton alloc] init];
    _leftBtn.backgroundColor = [UIColor clearColor];
    [_leftBtn setTitle:SOLocalizedStringFromTable(@"Manage Wallet", nil) forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[ApexUIHelper subThemeColor] forState:UIControlStateSelected];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _leftBtn.layer.cornerRadius = 5;
    
    _rightBtn = [[UIButton alloc] init];
    _rightBtn.backgroundColor = [UIColor clearColor];
    [_rightBtn setTitle:SOLocalizedStringFromTable(@"Transaction Records", nil) forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[ApexUIHelper subThemeColor] forState:UIControlStateSelected];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _rightBtn.layer.cornerRadius = 5;
    
    [self addSubview:_leftBtn];
    [self addSubview:_rightBtn];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.left.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(self.width/2.0-5);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self.leftBtn);
        make.width.equalTo(self.leftBtn);
    }];
    
    @weakify(self);
    [[_leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self selectLeftBtn];
    }];
    
    [[_rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self selectRightBtn];
    }];
    
    [self selectLeftBtn];
}

#pragma mark - action
- (void)selectLeftBtn{
    if (self.leftBtn.selected) {
        return;
    }
    self.leftBtn.backgroundColor = [UIColor whiteColor];
    self.rightBtn.backgroundColor = [ApexUIHelper subThemeColor];
    self.leftBtn.selected = YES;
    self.rightBtn.selected = NO;
    
    [self routeEventWithName:RouteNameEvent_SwitchHeaderManageWallet userInfo:@{}];
}

- (void)selectRightBtn{
    if (self.rightBtn.selected) {
        return;
    }
    self.rightBtn.backgroundColor = [UIColor whiteColor];
    self.leftBtn.backgroundColor = [ApexUIHelper subThemeColor];
    self.rightBtn.selected = YES;
    self.leftBtn.selected = NO;
    
    [self routeEventWithName:RouteNameEvent_SwitchHeaderTransactionRecord userInfo:@{}];
}

@end
