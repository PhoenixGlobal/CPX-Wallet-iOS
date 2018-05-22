//
//  UIResponder+Router.h
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2018/1/23.
//  Copyright © 2018年 迟钰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)
- (void)routeEventWithName:(NSString*)eventName userInfo:(NSDictionary*)userinfo;
@end
