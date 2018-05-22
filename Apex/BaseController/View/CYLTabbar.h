//
//  CYLTabbar.h
//  Apex
//
//  Created by chinapex on 2018/5/4.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RouteEventName_TabBarDidClicked @"RouteEventName_TabBarDidClicked"
#define KTabBarBtnTag @"KTabBarBtnTag"

@interface CYLTabbar : UITabBar
@property (nonatomic, strong) NSArray<UITabBarItem*> *itemsArr; /**< 按钮的tabbaritem数组 */
@property (nonatomic, assign) NSInteger initSelectTabbarBtnIndex; /**< 初始选中的tabbbar按钮 */
@end
