//
//  ApexCopyLable.m
//  Apex
//
//  Created by yulin chi on 2018/8/27.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexCopyLable.h"

@interface ApexCopyLable()

@end

@implementation ApexCopyLable
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self addSubview:self.accessoryView];
    [self.accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.mas_equalTo(10);
    }];
}

- (UIImageView *)accessoryView{
    if (!_accessoryView) {
        _accessoryView = [[UIImageView alloc] init];
        _accessoryView.image = [UIImage imageNamed:@"copy"];
    }
    return _accessoryView;
}
@end
