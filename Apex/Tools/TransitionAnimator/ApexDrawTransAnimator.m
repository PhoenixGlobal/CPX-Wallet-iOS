//
//  ApexDrawTransAnimator.m
//  Apex
//
//  Created by chinapex on 2018/6/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexDrawTransAnimator.h"

@interface ApexDrawTransAnimator()
@property (nonatomic, assign) CGFloat oriHeight; /**<  */
@property (nonatomic, strong) UIView *tabbarView; /**<  */
@end

@implementation ApexDrawTransAnimator

- (void)showAnimationWithDuration:(CGFloat)duration transitionStyle:(CYLTransitionStyle)style andtransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    switch (style) {
        case CYLTransitionStyle_Push:{
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UITabBarController *tabVC = fromVC.navigationController.tabBarController;
            UIView *container = [transitionContext containerView];
            
            self.fakeView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
            _fakeView.frame = fromVC.view.frame;
            _fakeView.alpha = 0.7;
            _fakeView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
            _fakeView.layer.shadowOffset = CGSizeMake(1, 0);
            _fakeView.layer.shadowOpacity = 1.0;
            _fakeView.hidden = NO;
            _oriHeight = _fakeView.height;
            
            self.tabbarView = [tabVC.tabBar snapshotViewAfterScreenUpdates:false];
            self.tabbarView.frame = tabVC.tabBar.frame;
            tabVC.tabBar.hidden = true;
            //为图片设置驱动手势
            [[ApexDrawTransPercentDriven shareDriven] setPercentDrivenForFakeView:_fakeView fromViewController:fromVC ToViewController:toVC drawTransFromDelta:delta];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [[[tap rac_gestureSignal] takeUntil:toVC.rac_willDeallocSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
                [toVC.navigationController popViewControllerAnimated:YES];
                [[ApexDrawTransPercentDriven shareDriven] startTranstionWithDuration:duration fromVC:toVC];
            }];
            [_fakeView addGestureRecognizer:tap];
            
            [container addSubview:toVC.view];
            [container addSubview:_fakeView];
            [container addSubview:_tabbarView];
            
            //animation setting
            UITableView *toTableView = toVC.view.subviews.lastObject;
            toTableView = [toTableView isKindOfClass:UITableView.class] ? toTableView : nil;
            toTableView.transform = CGAffineTransformMakeTranslation(delta, 0);
            
            
            [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
               
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.fakeView.height = kScreenH;
                        self.fakeView.transform = CGAffineTransformMakeTranslation(-scaleWidth375(delta), 0);
                        toTableView.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                    }];
                }];
                
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                    self.tabbarView.transform = CGAffineTransformMakeTranslation(0, 2*[ApexUIHelper tabBarHeight]);
                }];
                
            } completion:^(BOOL finished) {
                if (![transitionContext transitionWasCancelled]) {
                    [self.tabbarView removeFromSuperview];
                    [transitionContext completeTransition:YES];
                }else{
                    [transitionContext completeTransition:NO];
                }
            }];
            
            [[ApexDrawTransPercentDriven shareDriven] startTranstionWithDuration:duration fromVC:fromVC];
        }
            break;
            
        case CYLTransitionStyle_Pop:{
            
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UITabBarController *tabVC = toVC.navigationController.tabBarController;
            UIView *container = [transitionContext containerView];
            toVC.view.hidden = YES;
            
            [container addSubview:fromVC.view];
            [container addSubview:toVC.view];
            [container addSubview:_fakeView];
            [container addSubview:self.tabbarView];
            
            UITableView *fromTableView = fromVC.view.subviews.lastObject;
            fromTableView = [fromTableView isKindOfClass:UITableView.class] ? fromTableView : nil;
            
            @weakify(self);
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                @strongify(self);
                fromTableView.transform = CGAffineTransformMakeTranslation(delta, 0);
                self.fakeView.height = self.oriHeight;
                self.fakeView.transform = CGAffineTransformIdentity;
                self.fakeView.alpha = 1;
                self.tabbarView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
                if (![transitionContext transitionWasCancelled]) {
                    fromTableView.transform = CGAffineTransformIdentity;
                    toVC.view.hidden = NO;
//                    self.fakeView.hidden = YES;
                    tabVC.tabBar.hidden = false;
                    [self.fakeView removeFromSuperview];
                    [self.tabbarView removeFromSuperview];
                    [transitionContext completeTransition:YES];
                }else{
                    [transitionContext completeTransition:NO];
                }
                
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

- (void)clearRedundentView{
    [self.fakeView removeFromSuperview];
    [self.tabbarView removeFromSuperview];
}
@end
