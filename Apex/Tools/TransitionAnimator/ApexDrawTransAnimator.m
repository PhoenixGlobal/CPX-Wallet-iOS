//
//  ApexDrawTransAnimator.m
//  Apex
//
//  Created by chinapex on 2018/6/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexDrawTransAnimator.h"

@interface ApexDrawTransAnimator()
@property (nonatomic, strong) UIView *fakeView;
@end

@implementation ApexDrawTransAnimator

- (void)showAnimationWithDuration:(CGFloat)duration transitionStyle:(CYLTransitionStyle)style andtransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (style) {
        case CYLTransitionStyle_Push:{
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIView *container = [transitionContext containerView];
            
            self.fakeView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
            _fakeView.frame = fromVC.view.frame;
            _fakeView.alpha = 0.7;
            _fakeView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
            _fakeView.layer.shadowOffset = CGSizeMake(1, 0);
            _fakeView.layer.shadowOpacity = 1.0;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [[[tap rac_gestureSignal] takeUntil:toVC.rac_willDeallocSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                [toVC.navigationController popViewControllerAnimated:YES];
            }];
            [_fakeView addGestureRecognizer:tap];
            
            [container addSubview:toVC.view];
            [container addSubview:_fakeView];
            
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.fakeView.transform = CGAffineTransformMakeTranslation(-scaleWidth375(150), 0);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            
            }
            break;
            
        case CYLTransitionStyle_Pop:{
            
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIView *container = [transitionContext containerView];
            toVC.view.hidden = YES;
            
            [container addSubview:fromVC.view];
            [container addSubview:toVC.view];
            [container addSubview:_fakeView];
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.fakeView.transform = CGAffineTransformIdentity;
                self.fakeView.alpha = 1;
            } completion:^(BOOL finished) {
                self.fakeView.hidden = YES;
                toVC.view.hidden = NO;
                [transitionContext completeTransition:YES];
            }];
            
        }
        case CYLTransitionStyle_Present: {
            
            break;
        }
        case CYLTransitionStyle_Dismiss: {
        
            break;
        }
    }
}
@end
