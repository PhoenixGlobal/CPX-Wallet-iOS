//
//  NSString+Tool.h
//  Tool
//
//  Created by yulin chi on 2018/8/2.
//  Copyright © 2018年 yulin chi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  判断是否是空字符串 非空字符串 ＝ yes
 *
 *  @param string
 *
 *  @return
 */

#define  NOEmptyStr(string)  string == nil || string == NULL ||[string isKindOfClass:[NSNull class]] || [string isEqualToString: @""]  ||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 ? NO : YES

/**
 *  判断是否是空字符串 空字符串 = yes
 *
 *  @param string
 *
 *  @return
 */
#define  IsEmptyStr(string) string == nil || string == NULL ||[string isKindOfClass:[NSNull class]]|| [string isEqualToString:@""] ||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 ? YES : NO

@interface NSString (Tool)

#pragma mark -- 时间

//当前时间
+ (NSString *)nowDate;

//明天
+ (NSString *)nextDate;

// 将UTC日期字符串转为本地时间字符串
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;

//MD5加密
- (NSString *)md5WithString;
+ (NSString *)notRounding:(NSString *)price afterPoint:(int)position;
#pragma mark -- 正则判断

//手机号码验证
+ (BOOL)isMobile:(NSString *)mobile;

//邮箱
+ (BOOL)isEmail:(NSString *)email;

//验证码
+ (BOOL)isEmployeeNumber:(NSString *)number;

//正则匹配用户密码6-20位数字和字母组合
+ (BOOL)isPassword:(NSString *)password;

//正则匹配用户昵称2-12位
+ (BOOL)isNickName:(NSString *)nickName;

//金额
+ (BOOL)isMoneyNumber:(NSString *)number;

+ (BOOL)isAdress:(NSString *)adress;

+ (BOOL)isNEOAdress:(NSString *)adress;

////字符串前缀补0
+(NSString*)addString:(NSString*)string Length:(NSInteger)length OnString:(NSString*)str;

// data 转 json字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;

//// data 转 16进制字符串
+ (NSString *)hexStringFromData:(NSData *)myD;

//转16进账字符串
+ (NSString *)ToHex:(NSString *)string;

//精度计算
+ (NSString *)DecimalFuncWithOperatorType:(NSInteger)operatorType first:(id)first secend:(id)secend value:(int)value;

//精度比较
+ (NSComparisonResult)DecimalFuncComparefirst:(NSString *)first secend:(NSString *)secend;

/**
 字典转NSString
 */
+ (NSString *)dataTOjsonString:(id)object;

/**
 手机型号
 */
+ (NSString *)deviceType;

/**
 处理URL中含有空格和中文的情况
 
 @return 处理后的str
 */
/**
 替换标签

 @param html html
 @return str
 */
+ (NSString *)flattenHTML:(NSString *)html;

- (NSArray *)componentsSeparatedFromString:(NSString *)fromString toString:(NSString *)toString;
@end

