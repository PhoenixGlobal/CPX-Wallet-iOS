//
//  ApexCrypto.m
//  Apex
//
//  Created by chinapex on 2018/6/13.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexCrypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation ApexCrypto
+ (NSString *)hash256:(NSString *)string{
    const char *s = [string cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}
@end
