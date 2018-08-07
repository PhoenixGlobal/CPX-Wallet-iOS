//
//  ApexPrivacyAggreView.m
//  Apex
//
//  Created by chinapex on 2018/6/6.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexPrivacyAggreView.h"
@interface ApexPrivacyAggreView()
@end

@implementation ApexPrivacyAggreView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.privacyAgreeBtn];
    [self addSubview:self.privacyAgreeLable];
    
    [self.privacyAgreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.privacyAgreeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.privacyAgreeBtn.mas_right).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (UIButton *)privacyAgreeBtn{
    if (!_privacyAgreeBtn) {
        _privacyAgreeBtn = [[UIButton alloc] init];
        [_privacyAgreeBtn setImage:[UIImage imageNamed:@"Rectangle 13"] forState:UIControlStateNormal];
        [_privacyAgreeBtn setImage:[UIImage imageNamed:@"Group 4-1"] forState:UIControlStateSelected];
        [_privacyAgreeBtn setEnlargeEdge:20];
        @weakify(self);
        [[_privacyAgreeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.privacyAgreeBtn.selected = !self.privacyAgreeBtn.selected;
//            if (self.didClickAggreBtnSub) {
//                [self.didClickAggreBtnSub sendNext:@(self.privacyAgreeBtn.selected)];
//            }
        }];
    }
    return _privacyAgreeBtn;
}

- (UILabel *)privacyAgreeLable{
    if (!_privacyAgreeLable) {
        _privacyAgreeLable = [[UILabel alloc] init];
        _privacyAgreeLable.font = [UIFont systemFontOfSize:10];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:SOLocalizedStringFromTable(@"I agree to the Service and Privacy Policy", nil)];
        if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(15, 26)];
        }else{
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(11, 7)];
        }
        _privacyAgreeLable.attributedText = str;
    }
    return _privacyAgreeLable;
}
@end
