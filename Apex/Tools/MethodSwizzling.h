//
//  MethodSwizzling.h
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/9/10.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodSwizzling : NSObject
+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end
