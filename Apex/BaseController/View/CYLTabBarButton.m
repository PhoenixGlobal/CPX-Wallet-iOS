//
//  CYLTabBarButton.m
//  LoveFreshBeen山寨
//
//  Created by GARY on 16/4/27.
//  Copyright © 2016年 GARY. All rights reserved.
//

#import "CYLTabBarButton.h"

@interface CYLTabBarButton ()

@end

@implementation CYLTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.redDot = [[UIView alloc] init];
        self.redDot.backgroundColor = [UIColor redColor];
        self.redDot.hidden = YES;
        [self addSubview:self.redDot];
        
        [ApexUIHelper addLineInView:self color:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(0, 0, -1, 0)];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

#pragma mark - animation
- (void)doAnimation{
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"transform.scale";
    animation.values = @[@0.8,@1.2,@0.9,@1.0];
    animation.duration = 0.2;
    animation.removedOnCompletion = YES;
    animation.repeatCount = 1;
    [self.layer addAnimation:animation forKey:@""];
}

#pragma mark - layout
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect imageViewFrame = self.imageView.frame;
    
    if (_isOnlyPic) {
        return CGRectZero;
    }
    else
    {
        //设置title位置
        CGFloat height =  self.frame.size.height - CGRectGetMaxY(imageViewFrame);
        
        if (IS_IPHONE_X) {
            height -= 20;
        }
        
        CGRect frame = CGRectMake(0, CGRectGetMaxY(imageViewFrame), self.bounds.size.width,height);
        return frame;
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (_isOnlyPic) {
        CGFloat imageW = MIN(self.bounds.size.width, self.bounds.size.height);
        CGFloat x = (self.bounds.size.width - imageW) / 2.0 ;
        CGRect frame = CGRectMake(x, 0, imageW ,imageW);
        return frame;
    }
    else
    {
        //设置图片位置
//        CGFloat imageW = self.bounds.size.width / 3;
        CGFloat imageW = 25;
        CGRect frame = CGRectMake((self.bounds.size.width - imageW)/2, 6, imageW ,23);
        
        self.redDot.frame = CGRectMake(CGRectGetMaxX(frame)-3, frame.origin.y, 8, 8);
        self.redDot.layer.cornerRadius = 4;
        
        return frame;
    }
}


@end
