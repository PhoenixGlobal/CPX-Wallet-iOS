//
//  ApexDrawTransPercentDriven.m
//  Apex
//
//  Created by chinapex on 2018/6/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexDrawTransPercentDriven.h"

#define frame 30.0

@interface ApexDrawTransPercentDriven()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *drivenView;
@property (nonatomic, assign) CGFloat translateDelta;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIViewController *toVC;
@end

@implementation ApexDrawTransPercentDriven
singleM(Driven);

- (void)startPushWithDuration:(NSTimeInterval)duration{
    CGFloat delta = duration/frame;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:delta repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (self.percentComplete < 1) {
            [self updateInteractiveTransition:self.percentComplete + (1/frame)];
        }else{
            [self finishInteractiveTransition];
            [timer invalidate];
        }
    }];
    [timer fire];
}

- (void)startPopWithDuration:(NSTimeInterval)duration{
    CGFloat delta = duration/frame;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:delta repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (self.percentComplete > 0) {
            [self updateInteractiveTransition:self.percentComplete - (1/frame)];
        }else{
            [self finishInteractiveTransition];
            [timer invalidate];
        }
    }];
    [timer fire];
}

- (void)setPercentDrivenForFakeView:(UIView *)view ToViewController:(UIViewController *)viewController drawTransFromDelta:(CGFloat)delta{
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.drivenView = view;
    self.translateDelta = delta;
    self.toVC = viewController;
    [self.drivenView addGestureRecognizer:self.pan];
}

- (void)panGesture:(UIPanGestureRecognizer*)pan{
    CGPoint curP = [pan translationInView:[UIApplication sharedApplication].keyWindow];
    CGFloat percent = (curP.x/ self.translateDelta);
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            //更新进度前 一定要pop活着push控制器
            [self.toVC.navigationController popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:percent];
            NSLog(@"%f  %f", curP.x,percent);
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (percent*2.0 > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ------delegate-----


@end
