//
//  CYLTabbar.m
//  Apex
//
//  Created by chinapex on 2018/5/4.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "CYLTabbar.h"
#import "CYLTabBarButton.h"

@interface CYLTabbar()
@property (nonatomic, strong) NSMutableArray *btnArr;
@end

@implementation CYLTabbar
@synthesize itemsArr = _itemsArr;

- (void)setUpBtns{
    _btnArr = [NSMutableArray array];
    
    [_itemsArr enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        CYLTabBarButton *btn = [CYLTabBarButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        btn.titleLabel.font = [ApexUIHelper tabBarTitleFont];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTitleColor:[ApexUIHelper tabBarColor] forState:UIControlStateNormal];
        [btn setTitleColor:[ApexUIHelper tabBarSelectedColor] forState:UIControlStateSelected];
        
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        
        btn.backgroundColor = [UIColor clearColor];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn addTarget:self action:@selector(tabBarDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnArr addObject:btn];
        [self addSubview:btn];
    }];
}

- (void)layoutSubviews{
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width / _itemsArr.count;
    CGFloat btnH = self.frame.size.height;
    
    NSInteger count = self.btnArr.count;
    
    for (NSInteger i = 0; i < count; i ++) {
        CYLTabBarButton *btn = [CYLTabBarButton buttonWithType:UIButtonTypeCustom];
        if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_9_x_Max) {
            btn = self.btnArr[i];
        }
        else
        {
            btn = self.subviews[i];
        }
        
        btn.tag = i;
        
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
    }
    
    for (UIView *view in self.subviews) {
        
        if (![view isKindOfClass:[CYLTabBarButton class]]) {
            [view removeFromSuperview];
        }
        
        if ([view isKindOfClass:NSClassFromString(@"_UIBackdropEffectView")]) {
            view.backgroundColor = [UIColor whiteColor];
        }
    }
}

//- (void)didMoveToSuperview{
//    [self tabBarDidClicked:self.btnArr.firstObject];
//}


- (void)tabBarDidClicked:(CYLTabBarButton*)btn{
    
    for (CYLTabBarButton *btn in _btnArr) {
        btn.selected = NO;
    }
    [btn setSelected:YES];
    
    [self routeEventWithName:RouteEventName_TabBarDidClicked userInfo:@{KTabBarBtnTag:@(btn.tag)}];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    
    for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
        CGPoint convertedPoint = [subview convertPoint:point fromView:self];
        UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
        if (hitTestView) {
            return hitTestView;
        }
    }
    
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    return  self;
}

#pragma mark - setter
- (void)setInitSelectTabbarBtnIndex:(NSInteger)initSelectTabbarBtnIndex{
    _initSelectTabbarBtnIndex = initSelectTabbarBtnIndex;
    if (self.initSelectTabbarBtnIndex < self.btnArr.count) {
        CYLTabBarButton *btn = self.btnArr[self.initSelectTabbarBtnIndex];
        [self tabBarDidClicked:btn];
    }
}

- (void)setItemsArr:(NSArray<UITabBarItem *> *)itemsArr{
    _itemsArr = itemsArr;
    [self setUpBtns];
}
@end
