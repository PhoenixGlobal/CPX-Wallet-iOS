//
//  UIView+TKFrame.m
//  Thinking
//
//  Created by O*O on 16/11/19.
//  Copyright © 2016年 lane. All rights reserved.
//

#import "UIView+TKFrame.h"

@implementation UIView (TKFrame)

+ (CGFloat)fullScreenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)fullScreenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

- (UIView *)addLinecolor:(UIColor *)color edge:(UIEdgeInsets)edge
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    [self addSubview:line];
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
    }else if (edge.bottom <0){
        edge.bottom = -edge.bottom;
        H = @"H:|-left-[line]-right-|";
        V = @"V:|-top-[line(bottom)]";
    }else{
        [line removeFromSuperview];
        return nil;
    }
    NSDictionary *metrics = @{@"left": @(edge.left), @"right": @(edge.right), @"top": @(edge.top), @"bottom": @(edge.bottom)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:H options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:V options:0 metrics:metrics views:views]];
    return line;
}


@end
