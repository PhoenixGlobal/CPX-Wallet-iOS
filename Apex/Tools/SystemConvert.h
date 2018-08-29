//
//  SystemConvert.h
//  SystemConvert
//
//  Created by yulin chi on 2018/8/2.
//  Copyright © 2018年 yulin chi. All rights reserved.
//  进制转换类

#import <Foundation/Foundation.h>

@interface SystemConvert : NSObject
/**
 *  二进制 -> 十进制
 */
+ (NSString *)binaryToDecimal:(NSString *)binary;
/**
 *  二进制 -> 八进制
 */
+ (NSString *)binaryToQ:(NSString *)binary;
/**
 *  二进制 -> 十六进制
 */
+ (NSString *)binaryToHex:(NSString *)binary;

/**
 *  八进制 -> 二进制
 */
+ (NSString *)qToBinary:(NSString *)q;
/**
 *  八进制 -> 十进制
 */
+ (NSString *)qToDecimal:(NSString *)q;
/**
 *  八进制 -> 十六进制
 */
+ (NSString *)qToHex:(NSString *)q;


+ (NSData *)convertHexStrToData:(NSString *)str;

/**
 *  十进制 -> 二进制
 */
+ (NSString *)decimalToBinary:(NSUInteger)tmpid;
/**
 *  十进制 -> 八进制
 */
+ (NSString *)decimalToQ:(NSUInteger)tmpid;
/**
 *  十进制 -> 十六进制
 */
+ (NSString *)decimalToHex:(NSUInteger)tmpid;
/**
 *  十进制 -> 十六进制 不会溢出
 */
+ (NSString *)decimalStringToHex:(NSString*)tmpid;

/**
 *  十六进制 -> 二进制
 */
+ (NSString *)hexToBinary:(NSString *)hex;
/**
 *  十六进制 -> 八进制
 */
+ (NSString *)hexToQ:(NSString *)hex;
/**
 *  十六进制 -> 十进制 不会溢出
 */
+ (NSString *)hexToDecimal:(NSString *)hex;


@end
