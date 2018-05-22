//
//  CYLTabBarController.m
//  Apex
//
//  Created by chinapex on 2018/5/4.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "CYLTabBarController.h"
#import "CYLNavBaseController.h"
#import "CYLTabbar.h"
#import "ApexDiscoverController.h"
#import "ApexAssetController.h"
#import "ApexMineController.h"

@interface CYLTabBarController ()
@property (nonatomic, strong) NSMutableArray *tabBarItemsArr;
@property (nonatomic, strong) CYLTabbar *tabbar;
@end

@implementation CYLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabBarItemsArr = [NSMutableArray array];
    
    [self setAllViewControllers];
    
    [self prepareTabBar];
}

#pragma mark - 设置tabbar
- (void)prepareTabBar{
    _tabbar = [[CYLTabbar alloc] init];
    _tabbar.frame = self.tabBar.frame;
    _tabbar.itemsArr = _tabBarItemsArr;
    _tabbar.backgroundColor = [UIColor whiteColor];
    [self.tabBar removeFromSuperview];
    [self setValue:_tabbar forKey:@"tabBar"];
}

#pragma mark - 点击事件响应
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    //tabbar点击事件
    if ([eventName isEqualToString:RouteEventName_TabBarDidClicked]) {
        NSNumber *index = userinfo[KTabBarBtnTag];
        self.selectedIndex = index.integerValue;
    }
    
    [super routeEventWithName:eventName userInfo:userinfo];
}

- (void)setAllViewControllers{
    
    ApexDiscoverController *vc = [[ApexDiscoverController alloc] init];
    [self setOneViewController:vc image:[UIImage imageNamed:@"Page 1-1"] selImage:[UIImage imageNamed:@"Page 1-2"] title:@"发现"];
    
    ApexAssetController *vc1 = [[ApexAssetController alloc] init];
    [self setOneViewController:vc1 image:[UIImage imageNamed:@"叠加_块"] selImage:[UIImage imageNamed:@"叠加_块-1"] title:@"资产"];
    
    ApexMineController *vc2 = [[ApexMineController alloc] init];
    [self setOneViewController:vc2 image:[UIImage imageNamed:@"钱包"] selImage:[UIImage imageNamed:@"钱包-sel"] title:@"我的"];
    
}


- (void)setOneViewController:(UIViewController*)viewController image:(UIImage*)image selImage:(UIImage*)selImage title:(NSString*)title{
    CYLNavBaseController *nvc = [[CYLNavBaseController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nvc];
    UITabBarItem *item = [[UITabBarItem alloc] init];
    item.image = image;
    item.selectedImage = selImage;
    item.title = title;
    [_tabBarItemsArr addObject:item];
}

#pragma mark - setter
- (void)setInitSelectTabbarBtnIndex:(NSInteger)initSelectTabbarBtnIndex{
    _initSelectTabbarBtnIndex = initSelectTabbarBtnIndex;
    _tabbar.initSelectTabbarBtnIndex = self.initSelectTabbarBtnIndex;
}

@end
