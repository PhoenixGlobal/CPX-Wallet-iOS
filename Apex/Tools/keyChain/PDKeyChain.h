//
//  PDKeyChain.h
//  PDKeyChain
//
//  Created by Panda on 16/8/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface PDKeyChain : NSObject

/**
 *  存储字符串到 KeyChain
 *
 *  @param string NSString
 */
+ (void)keyChainSave:(NSString *)string;
+ (void)save:(NSString *)service data:(id)data;

/**
 *  从 KeyChain 中读取存储的字符串
 *
 *  @return NSString
 */
+ (NSString *)keyChainLoad;
+ (id)load:(NSString *)service;
/**
 *  删除 KeyChain 信息
 */
+ (void)keyChainDelete;
+ (void)delete:(NSString *)service;

@end
