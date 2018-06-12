//
//  ApexDrawTransPercentDriven.m
//  Apex
//
//  Created by chinapex on 2018/6/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

/*
 1.控制器的代理方法里需要返回此驱动控制类的实例
 2.在驱动调用updateInteractiveTransition:之前 要确保控制器已经开始转场既已经pop或者push过
 3.转场的过程则完全由updateInteractiveTransition:的百分比控制
 4.动画完成后要调用finishInteractiveTransition/cancelInteractiveTransition告知转场动画是否完成
 5.利用transitionContext判断转场动画是完成了还是取消了 从而来用[transitionContext completeTransition:YES/No]告知转场是否可以完成
 */

#import "ApexDrawTransPercentDriven.h"

#define frame 30.0
#define percentSubtle 0.1

@interface ApexDrawTransPercentDriven()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *drivenView;
@property (nonatomic, assign) CGFloat translateDelta;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIViewController *toVC;
@property (nonatomic, strong) UIViewController *fromVC;

@property (nonatomic, copy) void (^edgePanBlock)(UIScreenEdgePanGestureRecognizer *pan);
@end

@implementation ApexDrawTransPercentDriven
singleM(Driven);
/**无论是pop还是push percent都是从0->1的*/
- (void)startTranstionWithDuration:(NSTimeInterval)duration fromVC:(UIViewController *)fromVC{
    Class class = NSClassFromString(@"ApexMorePanelController");
    CGFloat delta = duration/frame;
    __block CGFloat progress = 0;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:delta repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (self.percentComplete < 1) {
            progress = self.percentComplete + (1/frame);
            //调节转场过程中的导航栏颜色
            if ([fromVC isKindOfClass:class]) {
                [fromVC.navigationController lt_setBackgroundColor:[ApexUIHelper navColorWithAlpha:progress]];

            }else{
                [fromVC.navigationController lt_setBackgroundColor:[ApexUIHelper navColorWithAlpha:(1 -progress)*percentSubtle]];
            }
            
            [self updateInteractiveTransition:progress];
        }else{
            [self finishInteractiveTransition];
            [timer invalidate];
        }
    }];
    [timer fire];
}

//- (void)startPushWithDuration:(NSTimeInterval)duration{
//    CGFloat delta = duration/frame;
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:delta repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (self.percentComplete < 1) {
//            CGFloat progress = self.percentComplete + (1/frame);
//            [self updateInteractiveTransition:progress];
//        }else{
//            [self finishInteractiveTransition];
//            [timer invalidate];
//        }
//    }];
//    [timer fire];
//}
//
//- (void)startPopWithDuration:(NSTimeInterval)duration{
//    CGFloat delta = duration/frame;
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:delta repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (self.percentComplete < 1) {
//            CGFloat progress = self.percentComplete + (1/frame);
//            [self updateInteractiveTransition:progress];
//        }else{
//            [self finishInteractiveTransition];
//            [timer invalidate];
//        }
//    }];
//    [timer fire];
//}

- (void)setPercentDrivenForFakeView:(UIView *)view fromViewController:(UIViewController *)fromVC ToViewController:(UIViewController *)viewController drawTransFromDelta:(CGFloat)delta{
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.drivenView = view;
    self.translateDelta = delta;
    self.toVC = viewController;
    self.fromVC = fromVC;
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
            [self updateInteractiveTransition:percent/1.5];
            [self.fromVC.navigationController lt_setBackgroundColor:[ApexUIHelper navColorWithAlpha:percent]];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if (percent*2.0 > 0.2) {
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

- (void)setPercentDrivenForFromViewController:(UIViewController*)fromVC edgePan:(void (^)(UIScreenEdgePanGestureRecognizer *))panGesture{
    self.edgePanBlock = panGesture;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePan:)];
    edgePan.edges = UIRectEdgeRight;
    [fromVC.view addGestureRecognizer:edgePan];
}

- (void)edgePan:(UIScreenEdgePanGestureRecognizer*)edgePan{
    if (self.edgePanBlock) {
        self.edgePanBlock(edgePan);
    }
}

@end
