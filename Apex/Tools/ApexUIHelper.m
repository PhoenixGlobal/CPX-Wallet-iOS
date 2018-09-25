//
//  ApexUIHelper.m
//  Apex
//
//  Created by chinapex on 2018/5/4.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexUIHelper.h"
#import "UIColor+HYF.h"

@implementation ApexUIHelper
+ (UIFont *)tabBarTitleFont{
    return [UIFont systemFontOfSize:11];
}

+ (UIColor *)tabBarColor{
    return [UIColor colorWithHexString:@"555555"];
}

+ (UIColor *)tabBarSelectedColor{
    return [UIColor colorWithHexString:@"1253BF"];
}

+ (UIColor *)textColor{
    return [UIColor colorWithHexString:@"666666"];
}

+ (UIColor*)grayColor{
    return [UIColor colorWithRed255:200 green255:200 blue255:200 alpha:1];
}

+ (UIColor*)grayColor240{
    return [UIColor colorWithRed255:240 green255:240 blue255:240 alpha:1];
}

+ (UIColor *)mainThemeColor{
    return [UIColor colorWithHexString:@"1253BF"];
}

+ (UIColor *)subThemeColor{
    return [UIColor colorWithHexString:@"1253BF"];
}

+ (UIColor *)navColor{
    return [UIColor colorWithRed255:30 green255:45 blue255:99 alpha:1];
}

+ (UIColor *)navColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed255:70 green255:105 blue255:214 alpha:alpha];
}

+ (CGFloat)naviBarHeight{
    static CGFloat height = 0;
    if (height == 0) {
        UINavigationController *naviVC = [UINavigationController new];
        height = CGRectGetHeight(naviVC.navigationBar.bounds) + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    }
    return height;
}

+ (CGFloat)tabBarHeight{
    static CGFloat tabbarHeight = 0;
    if (tabbarHeight == 0) {
        UITabBarController *tbvc = [UITabBarController new];
        tabbarHeight = tbvc.tabBar.height;
    }
    return tabbarHeight;
}

+ (UIView *)addLineInView:(UIView *)view color:(UIColor *)color edge:(UIEdgeInsets)edge{
    NSAssert(view != nil, @"addLineInView: view can not be nil");
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [view addSubview:line];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"line":line};
    NSString *H;
    NSString *V;
    if (edge.left <0) {
        edge.left = -edge.left;
        H = @"H:[line(left)]-right-|";
        V = @"V:|-top-[line]-bottom-|";
    }else if (edge.right <0){
        edge.right = -edge.right;
        H = @"H:|-left-[line(right)]";
        V = @"V:|-top-[line]-bottom-|";
    }else if (edge.top <0){
        edge.top = -edge.top;
        H = @"H:|-left-[line]-right-|";
        V = @"V:[line(top)]-bottom-|";
    }else if (edge.bottom < 0){
        edge.bottom = -edge.bottom;
        H = @"H:|-left-[line]-right-|";
        V = @"V:|-top-[line(bottom)]";
    }else{
        [line removeFromSuperview];
        return nil;
    }
    NSDictionary *metrics = @{@"left": @(edge.left), @"right": @(edge.right), @"top": @(edge.top), @"bottom": @(edge.bottom)};
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:H options:0 metrics:metrics views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:V options:0 metrics:metrics views:views]];
    return line;
}

+ (CGFloat)calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 9999) options:
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                  attributes:attribute context:nil];
    CGFloat height = rect.size.height + 1.0f;
    
    return height;
}

+ (CGFloat)calculateTextLength:(UIFont *)font givenText:(NSString *)text
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:
                        NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading
                                       attributes:attribute context:nil].size;
    CGFloat length = titleSize.width + 1.0f;
    
    return length;
}

+ (NSMutableAttributedString *)getCurrentGasPrice:(NSString *)gasGwei
{
    NSMutableAttributedString *attrStr = nil;
    NSString *string = @"";
    
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        string = [NSString stringWithFormat:@"Current GasPrice: %@ Gwei", gasGwei];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }else{
        string = [NSString stringWithFormat:@"当前gas单价: %@ Gwei", gasGwei];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([string rangeOfString:@":"].location + 2, gasGwei.length)];
    
    return attrStr;
}

+ (NSMutableAttributedString *)getTotalPrice:(NSString *)totalProce
{
    NSMutableAttributedString *attrStr = nil;
    NSString *string = @"";
    
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        string = [NSString stringWithFormat:@"Total: %@ ETH", totalProce];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }else{
        string = [NSString stringWithFormat:@"共: %@ ETH", totalProce];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([string rangeOfString:@":"].location + 2, totalProce.length)];
    
    return attrStr;
}

@end
