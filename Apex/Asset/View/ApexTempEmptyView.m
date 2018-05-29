//
//  ApexTempEmptyView.m
//  Apex
//
//  Created by chinapex on 2018/5/28.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTempEmptyView.h"

@implementation ApexTempEmptyView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.layer.cornerRadius = 3;
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 3-2"]];
    [self addSubview:iv];
    
    UILabel *l = [[UILabel alloc] init];
    l.text = @"暂无数据";
    l.font = [UIFont systemFontOfSize:15];
    l.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:l];
    
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(30);
    }];
    
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(iv.mas_bottom).offset(20);
    }];
}

@end
