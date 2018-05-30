//
//  ApexMnemonicShowCell.m
//  Apex
//
//  Created by chinapex on 2018/5/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexMnemonicShowCell.h"

@implementation ApexMnemonicShowCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    
    _showL = [[UILabel alloc] init];
    _showL.font = [UIFont systemFontOfSize:13];
    _showL.textColor = [UIColor blackColor];
    
    [self.contentView addSubview:_showL];
    [_showL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}
@end
