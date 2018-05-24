//
//  UILabel+Spacing.h
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/8/21.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Spacing)
/**
 修改label内容距 `top` `left` `bottom` `right` 边距
 */
@property (nonatomic, assign) UIEdgeInsets yf_contentInsets;
+ (void)setLabelSpace:(UILabel*)label withValue:(NSMutableAttributedString*)str withFont:(UIFont*)font withLineSpace:(CGFloat)space;
@end
