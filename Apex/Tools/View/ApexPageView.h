//
//  ApexPageView.h
//  Apex
//
//  Created by yulin chi on 2018/7/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApexPageView;
@protocol ApexPageViewDelegate<NSObject>
- (NSInteger)numberOfPageInPageView;
- (UIView*)pageView:(ApexPageView*)pageView viewForPageAtIndex:(NSInteger)index;
- (NSString*)pageView:(ApexPageView*)pageView titleForPageAtIndex:(NSInteger)index;
@end

@interface ApexPageView : UIView
@property (nonatomic, weak) id<ApexPageViewDelegate> delegate;
@end
