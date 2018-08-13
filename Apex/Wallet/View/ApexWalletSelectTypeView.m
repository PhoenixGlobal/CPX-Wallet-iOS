//
//  ApexWalletSelectTypeView.m
//  Apex
//
//  Created by yulin chi on 2018/8/13.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexWalletSelectTypeView.h"

@interface ApexWalletSelectTypeView()
@property (nonatomic, strong) UIImageView *rightView; /**<  */
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *clearBtn; /**<  */
@end

@implementation ApexWalletSelectTypeView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _typeTF = [[UITextField alloc] init];
    _typeTF.font = [UIFont systemFontOfSize:13];
    _typeTF.borderStyle = UITextBorderStyleNone;
    _typeTF.enabled = false;
    _typeTF.placeholder = SOLocalizedStringFromTable(@"CreateType", nil);
    [self addSubview:_typeTF];
    [_typeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _rightView = [[UIImageView alloc] init];
    _rightView.image = [UIImage imageNamed:@"arrows-1_minimal-left"];
    [self addSubview:_rightView];
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    _clearBtn = [[UIButton alloc] init];
    [_clearBtn setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_clearBtn];
    @weakify(self);
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.typeTF);
    }];
    [[_clearBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.didChooseTypeSub) {
            [self.didChooseTypeSub sendNext:@""];
        }
    }];
    
    self.bottomLine = [ApexUIHelper addLineInView:self color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
}
@end
