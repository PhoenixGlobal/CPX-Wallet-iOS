//
//  UIView+TKFrame.h
//  Thinking
//
//  Created by O*O on 16/11/19.
//  Copyright © 2016年 lane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TKFrame)

+ (CGFloat)fullScreenWidth;
+ (CGFloat)fullScreenHeight;

- (CGFloat)left;
- (CGFloat)right;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGSize)size;

- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setTop:(CGFloat)top;
- (void)setBottom:(CGFloat)bottom;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setOrigin:(CGPoint)point;
- (void)setSize:(CGSize)size;
- (UIView *)addLinecolor:(UIColor *)color edge:(UIEdgeInsets)edge;

@end
