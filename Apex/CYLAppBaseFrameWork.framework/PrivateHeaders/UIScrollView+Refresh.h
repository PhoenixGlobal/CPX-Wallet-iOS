//
//  UIScrollView+Referesh.h
//  CYLReferesh
//
//  Created by chinapex on 2018/4/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Refresh)
- (void)addHeaderRefreshAction:(void (^)(void))Action;
- (void)endHeaderRefresh;

- (void)addFooterRfreshAction:(void(^)(void))Action;
- (void)endFooterRefresh;
- (void)endFooterRefreshNoMoreData;
@end
