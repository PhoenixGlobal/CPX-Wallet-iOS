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
    return [UIColor colorWithHexString:@"4c8efa"];
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
    return [UIColor colorWithHexString:@"4c8efa"];
}

+ (UIColor *)subThemeColor{
    return [UIColor colorWithHexString:@"4C8EFA"];
}

+ (UIColor *)navColor{
    return [UIColor colorWithRed255:70 green255:105 blue255:214 alpha:1];
}

+ (CGFloat)naviBarHeight{
    static CGFloat height = 0;
    if (height == 0) {
        UINavigationController *naviVC = [UINavigationController new];
        height = CGRectGetHeight(naviVC.navigationBar.bounds) + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    }
    return height;
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
@end
