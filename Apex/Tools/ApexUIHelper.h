//
//  ApexUIHelper.h
//  Apex
//
//  Created by chinapex on 2018/5/4.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexUIHelper : NSObject
+ (UIFont*)tabBarTitleFont;

+ (CGFloat)naviBarHeight;
+ (CGFloat)tabBarHeight;

+ (UIColor *)navColorWithAlpha:(CGFloat)alpha;
+ (UIColor*)navColor;
+ (UIColor*)tabBarColor;
+ (UIColor*)tabBarSelectedColor;
+ (UIColor*)grayColor;
+ (UIColor*)grayColor240;
+ (UIColor*)mainThemeColor;
+ (UIColor *)subThemeColor;
+ (UIColor*)textColor;

/**< 添加线条 */
+ (UIView *)addLineInView:(UIView *)view color:(UIColor *)color edge:(UIEdgeInsets)edge;

//获取label的高度
+ (CGFloat)calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width;

//获取label的宽度
+ (CGFloat)calculateTextLength:(UIFont *)font givenText:(NSString *)text;

+ (NSMutableAttributedString *)getCurrentGasPrice:(NSString *)gasGwei;

+ (NSMutableAttributedString *)getTotalPrice:(NSString *)totalProce;

@end
