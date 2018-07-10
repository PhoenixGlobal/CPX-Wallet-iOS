//
//  UINavigationController+ZJNNavigationBar.h
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/7/28.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ApexNavigationBar)
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setTranslationY:(CGFloat)translationY;
//- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_reset;
- (void)setNeedsNavigationBackground:(CGFloat)alpha;
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;
- (UIView*)barBackgroundView;
- (void)showImageOnNavigationBar:(UIImage*)image;

@property (nonatomic, strong) UIView *overlay;
@end
