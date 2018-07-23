//
//  ApexLoading.m
//  Apex
//
//  Created by yulin chi on 2018/7/20.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexLoading.h"

static CGFloat percentRatio= 0.66; /* panellayer占用coverview的垂直比例 */
static CGFloat messagePadding = 25; /* messageL的左右padding */
static CGFloat KcenterCircleRadiusPercent = 0.1; /* 中心圆'半径'占panel宽的百分比 */
static CGFloat KmiddleCircleRadiusPercent = 0.15;
static CGFloat KoutterCircleRadiusPercent = 0.20;
static CGFloat KlineWidth = 2;

@interface ApexLoading()<CAAnimationDelegate>
@property (nonatomic, strong) UIView *coverView; /**<  */
@property (nonatomic, strong) UILabel *messageL; /**<  */
@property (nonatomic, strong) CALayer *panelLayer; /**<  */
@property (nonatomic, strong) CAShapeLayer *centerCircleLayer; /**<  */
@property (nonatomic, strong) CAShapeLayer *middleCircleLayer; /**<  */
@property (nonatomic, strong) CAShapeLayer *outterCircleLayer; /**<  */
@property (nonatomic, assign) BOOL shouldEndAnimation; /**< 强制一段动画才允许hide loading */
@end

@implementation ApexLoading
#pragma mark - show method
+ (void)showOnView:(UIView*)superView Message:(NSString*)message{
    ApexLoading *loading = [[ApexLoading alloc] initWithFrame:superView.bounds];
    loading.messageL.text = message;
    [superView addSubview:loading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loading startAnimation];
    });
}

+ (void)hideOnView:(UIView*)superView{
    for (UIView *hud in [superView.subviews reverseObjectEnumerator].allObjects) {
        if ([hud isKindOfClass:ApexLoading.class]) {
            ApexLoading *apexloading = (ApexLoading*)hud;
            [apexloading hideAnimation];
            break;
        }
    }
}

#pragma mark - private method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.coverView];
    [self.coverView.layer addSublayer:self.panelLayer];
    [self.coverView addSubview:self.messageL];
    self.panelLayer.frame = CGRectMake(0, 0, self.coverView.width, (self.coverView.height * percentRatio));
    self.messageL.frame = CGRectMake(messagePadding, CGRectGetMaxY(self.panelLayer.frame), self.coverView.width-(messagePadding*2), self.coverView.height * (1 - percentRatio));

    
    [self.panelLayer addSublayer:self.centerCircleLayer];
    [self.panelLayer addSublayer:self.middleCircleLayer];
    [self.panelLayer addSublayer:self.outterCircleLayer];
    
   
    [self configCenterCirclePath];
    [self configMiddleCirclePath];
    [self configOutterCirclePath];
    
    self.centerCircleLayer.strokeEnd = 0;
    self.middleCircleLayer.strokeEnd = 0;
    self.outterCircleLayer.strokeEnd = 0;
}

- (void)configCenterCirclePath{
    //center
    CGFloat panelCenterX = self.panelLayer.bounds.size.width/2.0;
    CGFloat panelCenterY = self.panelLayer.bounds.size.height/2.0;
    CGFloat radius = self.panelLayer.bounds.size.width*KcenterCircleRadiusPercent;

    _centerCircleLayer.frame = CGRectMake(panelCenterX-radius, panelCenterY-radius, 2*radius, 2*radius);
    _centerCircleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    
    //path的坐标是相对于其作用的layer而定的
    UIBezierPath *centerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI*(7/4.0) endAngle:M_PI*(3/2.0) clockwise:YES];
    self.centerCircleLayer.path = centerPath.CGPath;
}

- (void)configMiddleCirclePath{
    CGFloat panelCenterX = self.panelLayer.frame.origin.x + self.panelLayer.bounds.size.width/2.0;
    CGFloat panelCenterY = self.panelLayer.frame.origin.y + self.panelLayer.bounds.size.height/2.0;
    CGFloat radius = self.panelLayer.bounds.size.width*KmiddleCircleRadiusPercent;
    
    _middleCircleLayer.frame = CGRectMake(panelCenterX-radius, panelCenterY-radius, 2*radius, 2*radius);
    _middleCircleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    
    UIBezierPath *middlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI*0.3 endAngle:M_PI * 2 clockwise:YES];
    self.middleCircleLayer.path = middlePath.CGPath;
}

- (void)configOutterCirclePath{
    CGFloat panelCenterX = self.panelLayer.frame.origin.x + self.panelLayer.bounds.size.width/2.0;
    CGFloat panelCenterY = self.panelLayer.frame.origin.y + self.panelLayer.bounds.size.height/2.0;
    CGFloat radius = self.panelLayer.bounds.size.width*KoutterCircleRadiusPercent;
    
    _outterCircleLayer.frame = CGRectMake(panelCenterX-radius, panelCenterY-radius, 2*radius, 2*radius);
    _outterCircleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    
    UIBezierPath *outterPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:M_PI*0.7 clockwise:YES];
    self.outterCircleLayer.path = outterPath.CGPath;
}

- (void)startAnimation{
    
    CABasicAnimation *StrokeAnim = [CABasicAnimation animation];
    StrokeAnim.keyPath = @"strokeEnd";
    StrokeAnim.removedOnCompletion = NO;
    StrokeAnim.repeatCount = 0;
    StrokeAnim.toValue = @(1.0);
    StrokeAnim.fillMode = kCAFillModeForwards;
    StrokeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *centerStroke = [StrokeAnim copy];
    centerStroke.delegate = self;
    centerStroke.duration = 0.4;
    [_centerCircleLayer addAnimation:centerStroke forKey:@"centerStroke"];
    
    CABasicAnimation *middleStroke = [StrokeAnim copy];
    middleStroke.duration = 0.6;
    middleStroke.delegate = self;
    [_middleCircleLayer addAnimation:middleStroke forKey:@"middleStroke"];
    
    CABasicAnimation *outterStroke = [StrokeAnim copy];
    outterStroke.duration = 0.8;
    outterStroke.delegate = self;
    [_outterCircleLayer addAnimation:outterStroke forKey:@"outterStroke"];
    
}

- (void)hideAnimation{
    [[RACObserve(self, shouldEndAnimation) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *shouldEnd) {
        if (shouldEnd.boolValue) {
            [UIView animateWithDuration:0.3 animations:^{
                self.coverView.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }];
}

#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    CABasicAnimation *rotate = [[CABasicAnimation alloc] init];
    rotate.keyPath = @"transform.rotation.z";
    rotate.fromValue = @(0);
    rotate.toValue = @(M_PI * 2);
    rotate.repeatCount = NSIntegerMax;
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    
    if (anim == [_centerCircleLayer animationForKey:@"centerStroke"]) {
        rotate.duration = 1.0;
        [_centerCircleLayer addAnimation:rotate forKey:nil];
        
    }else if(anim == [_middleCircleLayer animationForKey:@"middleStroke"]){
        rotate.duration = 1.5;
        [_middleCircleLayer addAnimation:rotate forKey:nil];
        
    }else if (anim == [_outterCircleLayer animationForKey:@"outterStroke"]){
        rotate.duration = 2.0;
        [_outterCircleLayer addAnimation:rotate forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.shouldEndAnimation = YES;
        });
    }
}

#pragma mark - getter setter
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2.0 - 65, self.height/2.0 - 75, 110, 120)];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _coverView.layer.cornerRadius = 6;
        _coverView.layer.masksToBounds = YES;
    }
    return _coverView;
}

- (UILabel *)messageL{
    if (!_messageL) {
        _messageL = [[UILabel alloc] init];
        _messageL.textColor = [UIColor whiteColor];
        _messageL.font = [UIFont systemFontOfSize:14];
        _messageL.textAlignment = NSTextAlignmentCenter;
        _messageL.numberOfLines = 2;
    }
    return _messageL;
}

- (CALayer *)panelLayer{
    if (!_panelLayer) {
        _panelLayer = [[CALayer alloc] init];
        _panelLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _panelLayer;
}

- (CAShapeLayer *)centerCircleLayer{
    if (!_centerCircleLayer) {
        _centerCircleLayer = [[CAShapeLayer alloc] init];
        _centerCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _centerCircleLayer.strokeColor = [UIColor colorWithHexString:@"B3D2FF"].CGColor;
        _centerCircleLayer.lineWidth = KlineWidth;
        _centerCircleLayer.lineCap = kCALineCapRound;
    }
    return _centerCircleLayer;
}

- (CAShapeLayer *)middleCircleLayer{
    if (!_middleCircleLayer) {
        _middleCircleLayer = [[CAShapeLayer alloc] init];
        _middleCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _middleCircleLayer.strokeColor = [UIColor colorWithHexString:@"4C8EFA"].CGColor;
        _middleCircleLayer.lineWidth = KlineWidth;
        _middleCircleLayer.lineCap = kCALineCapRound;
    }
    return _middleCircleLayer;
}

- (CAShapeLayer *)outterCircleLayer{
    if (!_outterCircleLayer) {
        _outterCircleLayer = [[CAShapeLayer alloc] init];
        _outterCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _outterCircleLayer.strokeColor = [UIColor colorWithHexString:@"ABCDFF"].CGColor;
        _outterCircleLayer.lineWidth = KlineWidth;
        _outterCircleLayer.lineCap = kCALineCapRound;
    }
    return _outterCircleLayer;
}
@end
