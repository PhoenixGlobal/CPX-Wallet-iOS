//
//  NSBundle+MJLocalization.m
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "NSBundle+MJLocalization.h"
#import "SOLocalization.h"

@implementation NSBundle (MJLocalization)
+ (void)load
{
    // 交换MJ的国际化方法
    Method mjMethod = class_getClassMethod([NSBundle class],@selector(mj_localizedStringForKey:value:));
    Method myMethod = class_getClassMethod(self, @selector(hook_mj_localizedStringForKey:value:));
    method_exchangeImplementations(mjMethod, myMethod);
}

/// hook刷新控件的提示文字
+ (NSString *)hook_mj_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    NSString *language =  [SOLocalization sharedLocalization].region;
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mj_refreshBundle] pathForResource:language ofType:@"lproj"]];
    return [bundle localizedStringForKey:key value:nil table:@"Localizable"];
}
@end
