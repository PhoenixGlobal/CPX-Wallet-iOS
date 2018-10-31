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
//    [self text];
#ifdef DEBUG
    return baseUrl_cli_main;
#endif
    return baseUrl_cli_main;
}

+ (NSString*)getETHBaseUrl{
    return ETH_baseUrl_cli_Main;
}

+ (NSString *)getToolBaseUrl{
#ifdef DEBUG
//    return baseUrl_tool_test;
    return baseUrl_tool_main;
#endif
    return baseUrl_tool_main;
}

+ (void)text{
    NSString *s = NeomobileDecodeAddress(@"ALDbmTMY54RZnLmibH3eXfHvrZt4fLiZhh", nil);
    
    
    NSLog(@"%@",s);
}

/**
 将16进制的字符串转换成NSData
 */
+ (NSData *)convertHexStrToData:(NSString *)str {
    NSString *balance = [NSString stringWithFormat:@"%@", str];
    if (!balance || [balance length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([balance length] %2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [balance length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [balance substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return [hexData copy];
}

/**
 byte转换成余额
 */
+ (unsigned long long)getBalanceWithByte:(Byte *)byte length:(NSInteger)length {
    
    Byte newByte[length];
    for (NSInteger i = 0; i < length; i++) {
        newByte[i] = byte[length - i - 1];
    }
    
    NSString *hexStr = @"";
    for(int i=0;i < length;i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",newByte[i]&0xff]; // 16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    NSScanner * scanner = [NSScanner scannerWithString:hexStr];
    
    unsigned long long balance;
    
    [scanner scanHexLongLong:&balance];
    
    return balance;
}

@end
