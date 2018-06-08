//
//  ApexNetWorkCommonConfig.m
//  Apex
//
//  Created by chinapex on 2018/6/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexNetWorkCommonConfig.h"

@implementation ApexNetWorkCommonConfig
+ (NSString *)getCliBaseUrl{
#ifdef DEBUG
//    return baseUrl_cli_test;
    return baseUrl_cli_main;
#endif
    return baseUrl_cli_main;
}

+ (NSString *)getToolBaseUrl{
#ifdef DEBUG
//    return baseUrl_tool_test;
    return baseUrl_tool_main;
#endif
    return baseUrl_tool_main;
}
@end
