//
//  SystemConvert.m
//  SystemConvert
//
//  Created by yulin chi on 2018/8/2.
//  Copyright © 2018年 yulin chi. All rights reserved.

#import "SystemConvert.h"


static NSMutableDictionary *_bitHexDic;
static NSMutableDictionary *_tenHexDic;
static NSMutableDictionary *_bitQDic;

@implementation SystemConvert

+ (NSMutableDictionary *)bitHexDic{
    if(_bitHexDic == nil){
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:16];
        
        [hex setObject:@"0000" forKey:@"0"];
        
        [hex setObject:@"0001" forKey:@"1"];
        
        [hex setObject:@"0010" forKey:@"2"];
        
        [hex setObject:@"0011" forKey:@"3"];
        
        [hex setObject:@"0100" forKey:@"4"];
        
        [hex setObject:@"0101" forKey:@"5"];
        
        [hex setObject:@"0110" forKey:@"6"];
        
        [hex setObject:@"0111" forKey:@"7"];
        
        [hex setObject:@"1000" forKey:@"8"];
        
        [hex setObject:@"1001" forKey:@"9"];
        
        [hex setObject:@"1010" forKey:@"A"];
        
        [hex setObject:@"1011" forKey:@"B"];
        
        [hex setObject:@"1100" forKey:@"C"];
        
        [hex setObject:@"1101" forKey:@"D"];
        
        [hex setObject:@"1110" forKey:@"E"];
        
        [hex setObject:@"1111" forKey:@"F"];
        
        _bitHexDic = hex;
    }
    return _bitHexDic;
}

+ (NSMutableDictionary *)tenHexDic{
    if(_tenHexDic == nil){
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:16];
        
        [hex setObject:@"0" forKey:@"0"];
        
        [hex setObject:@"1" forKey:@"1"];
        
        [hex setObject:@"2" forKey:@"2"];
        
        [hex setObject:@"3" forKey:@"3"];
        
        [hex setObject:@"4" forKey:@"4"];
        
        [hex setObject:@"5" forKey:@"5"];
        
        [hex setObject:@"6" forKey:@"6"];
        
        [hex setObject:@"7" forKey:@"7"];
        
        [hex setObject:@"8" forKey:@"8"];
        
        [hex setObject:@"9" forKey:@"9"];
        
        [hex setObject:@"A" forKey:@"10"];
        
        [hex setObject:@"B" forKey:@"11"];
        
        [hex setObject:@"C" forKey:@"12"];
        
        [hex setObject:@"D" forKey:@"13"];
        
        [hex setObject:@"E" forKey:@"14"];
        
        [hex setObject:@"F" forKey:@"15"];
        
        _tenHexDic = hex;
    }
    return _tenHexDic;
}

+ (NSMutableDictionary *)bitQDic{
    if(_bitQDic == nil){
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:8];
        
        [hex setObject:@"000" forKey:@"0"];
        
        [hex setObject:@"001" forKey:@"1"];
        
        [hex setObject:@"010" forKey:@"2"];
        
        [hex setObject:@"011" forKey:@"3"];
        
        [hex setObject:@"100" forKey:@"4"];
        
        [hex setObject:@"101" forKey:@"5"];
        
        [hex setObject:@"110" forKey:@"6"];
        
        [hex setObject:@"111" forKey:@"7"];
        
        _bitQDic = hex;
    }
    return _bitQDic;

}


/**
 *  二进制 -> 十进制
 */
+ (NSString *)binaryToDecimal:(NSString *)binary{
    //1110110
    NSUInteger decimal = 0;
    for (NSInteger index = 0; index < binary.length; index++) {
        double num = [[binary substringWithRange:(NSRange){binary.length - index - 1, 1}] doubleValue];
        decimal +=  num * pow(2, index);
    }
    return [NSString stringWithFormat:@"%ld", decimal];
}
/**
 *  二进制 -> 八进制
 */
+ (NSString *)binaryToQ:(NSString *)binary{
    return [self decimalToQ:[[self binaryToDecimal:binary] integerValue]];
}
/**
 *  二进制 -> 十六进制
 */
+ (NSString *)binaryToHex:(NSString *)binary{
    return [self decimalToHex:[[self binaryToDecimal:binary] integerValue]];
}

/**
 *  八进制 -> 二进制
 */
+ (NSString *)qToBinary:(NSString *)q{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSUInteger count = q.length;
    for (NSInteger index = 0; index < count; index++) {
        NSString *appendStr = [[self bitQDic] objectForKey:[q substringWithRange:(NSRange){index, 1}]];
        if(index == 0){
            appendStr = [NSString stringWithFormat:@"%ld", [appendStr integerValue]];
        }
        [str appendString:appendStr];
    }
    return str;
}
/**
 *  八进制 -> 十进制
 */
+ (NSString *)qToDecimal:(NSString *)q{
    return [self binaryToDecimal:[self qToBinary:q]];
}
/**
 *  八进制 -> 十六进制
 */
+ (NSString *)qToHex:(NSString *)q{
    return [self binaryToHex:[self qToBinary:q]];
}

+ (NSString *)tenToOtherWithNum:(NSUInteger)num system:(NSUInteger)system{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    while (num)
    {
        [str insertString:[NSString stringWithFormat:@"%ld", num % system] atIndex:0];
        num /= system;
    }
    return str;
}
/**
 *  十进制 -> 二进制
 */
+ (NSString *)decimalToBinary:(NSUInteger)tmpid{
    return [self tenToOtherWithNum:tmpid system:2];
}
/**
 *  十进制 -> 八进制
 */
+ (NSString *)decimalToQ:(NSUInteger)tmpid{
    return [self tenToOtherWithNum:tmpid system:8];
}
/**
 *  十进制 -> 十六进制
 */
+ (NSString *)decimalToHex:(NSUInteger)tmpid{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    while (tmpid) {
        [str insertString:[[self tenHexDic] objectForKey:[NSString stringWithFormat:@"%ld", tmpid % 16]] atIndex:0];
        tmpid /= 16;
    }
    return str;
}
/**
 *  十六进制 -> 二进制
 */
+ (NSString *)hexToBinary:(NSString *)hex{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSUInteger count = hex.length;
    for (NSInteger index = 0; index < count; index++) {
        NSString *appendStr = [[self bitHexDic] objectForKey:[hex substringWithRange:(NSRange){index, 1}]];
        if(index == 0){
            //过滤前面的0
            appendStr = [NSString stringWithFormat:@"%ld", [appendStr integerValue]];
        }
        if (appendStr)
        {
            [str appendString:appendStr];
        }
    }
    return str;
}
/**
 *  十六进制 -> 八进制
 */
+ (NSString *)hexToQ:(NSString *)hex{
    return [self binaryToQ:[self hexToBinary:hex]];
}
/**
 *  十六进制 -> 十进制
 */
+ (NSString *)hexToDecimal:(NSString *)hex{
    return [self binaryToDecimal:[self hexToBinary:hex]];
}
@end
