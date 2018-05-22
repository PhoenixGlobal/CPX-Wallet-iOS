//
//  ApexNoDetailDataView.m
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexNoDetailDataView.h"

@interface ApexNoDetailDataView()
@property (nonatomic, strong) UIImageView *emptyIV;
@property (nonatomic, strong) UILabel *tipL;
@end

@implementation ApexNoDetailDataView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - private
- (void)setUI{
    _emptyIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 3-2"]];
    [self addSubview:_emptyIV];
    
    _tipL = [[UILabel alloc] init];
    
}

#pragma mark - getter setter
@end
