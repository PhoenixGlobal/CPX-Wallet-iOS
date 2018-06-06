//
//  ApexImportSwithHeaderBar.m
//  Apex
//
//  Created by chinapex on 2018/6/6.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexImportSwithHeaderBar.h"
@interface ApexImportSwithHeaderBar()
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation ApexImportSwithHeaderBar
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
    self.layer.cornerRadius = 5;
    
    _leftBtn = [[UIButton alloc] init];
    _leftBtn.backgroundColor = [UIColor clearColor];
    [_leftBtn setTitle:@"助记词" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[ApexUIHelper subThemeColor] forState:UIControlStateSelected];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _leftBtn.layer.cornerRadius = 5;
    
    _rightBtn = [[UIButton alloc] init];
    _rightBtn.backgroundColor = [UIColor clearColor];
    [_rightBtn setTitle:@"keystore" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[ApexUIHelper subThemeColor] forState:UIControlStateSelected];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _rightBtn.layer.cornerRadius = 5;
    
    [self addSubview:_leftBtn];
    [self addSubview:_rightBtn];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(2);
        make.bottom.equalTo(self).offset(-2);
        make.width.mas_equalTo(self.width/2.0-5);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
        make.bottom.equalTo(self.leftBtn).offset(-2);
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
    
    [self routeEventWithName:RouteNameEvent_ImportWalletByKeystore userInfo:@{}];
}

- (void)selectRightBtn{
    if (self.rightBtn.selected) {
        return;
    }
    self.rightBtn.backgroundColor = [UIColor whiteColor];
    self.leftBtn.backgroundColor = [ApexUIHelper subThemeColor];
    self.rightBtn.selected = YES;
    self.leftBtn.selected = NO;
    
    [self routeEventWithName:RouteNameEvent_ImportWalletByMnemonic userInfo:@{}];
}


@end
