//
//  CYLBaseTransitionAnimation.h
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/16.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CYLTransitionStyle) {
    CYLTransitionStyle_Pop,
    CYLTransitionStyle_Push,
    CYLTransitionStyle_Present,
    CYLTransitionStyle_Dismiss
};

@interface CYLBaseTransitionAnimation : NSObject
- (void)showAnimationWithDuration:(CGFloat)duration transitionStyle:(CYLTransitionStyle)style andtransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
@end
