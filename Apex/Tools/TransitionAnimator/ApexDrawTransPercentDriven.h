//
//  ApexDrawTransPercentDriven.h
//  Apex
//
//  Created by chinapex on 2018/6/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexDrawTransPercentDriven : UIPercentDrivenInteractiveTransition
singleH(Driven);
- (void)startPushWithDuration:(NSTimeInterval)duration;
- (void)startPopWithDuration:(NSTimeInterval)duration;

- (void)setPercentDrivenForFakeView:(UIView*)view ToViewController:(UIViewController*)viewController drawTransFromDelta:(CGFloat)delta;

@end
