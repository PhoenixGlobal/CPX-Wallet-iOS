//
//  ApexNeoTxStatusManager.h
//  Apex
//
//  Created by yulin chi on 2018/8/28.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
//管理neo交易的状态追踪(上链前/后)
@interface ApexNeoTxStatusManager : NSObject
+ (void)initTrackerDict;

+ (void)writeTxWithTXID:(NSString*)txid;
//此笔交易是否超过六个块还没有上链 若没有这判定交易失败
+ (void)tracingTXStatus:(NSString *)txid noResponseBlock:(void (^)(BOOL isResponding))block;

+ (void)tracingTxStatusSuccess:(NSString*)txid;
@end
