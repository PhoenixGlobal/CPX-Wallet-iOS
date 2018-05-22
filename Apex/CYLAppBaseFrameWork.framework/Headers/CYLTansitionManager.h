//
//  CYLBaseTansition.h
//  CYLTransitioning
//
//  Created by 迟钰林 on 2017/6/16.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CYLBaseTransitionAnimation.h"

@interface CYLTansitionManager : NSObject<UIViewControllerAnimatedTransitioning>

+ (id<UIViewControllerAnimatedTransitioning>)transitionObjectwithTransitionStyle:(CYLTransitionStyle)style animateDuration:(CGFloat)duration andTransitionAnimation:(CYLBaseTransitionAnimation*)animator;

@end
