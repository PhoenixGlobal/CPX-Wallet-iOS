//
//  ETHTxStatusManager.h
//  Apex
//
//  Created by yulin chi on 2018/9/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

//管理以太坊交易上链后的状态追踪
@interface ETHTxStatusManager : NSObject
+ (void)initTrackerDict;

+ (void)writeTxWithTXID:(NSString*)txid currentBlockNumber:(NSString*)cur;

//开始12个块的确认
+ (void)beginConfirmationCountDownWithConfirmationNumber:(NSInteger)confirmNum txid:(NSString*)txid doneBlock:(dispatch_block_t)doneBlock;

//交易receipt未返回前的监控
+ (void)txStatusMonitor:(NSString*)txid address:(NSString*)address nonce:(NSString*)theNonce timeOutBlock:(dispatch_block_t)timeOutBlock;
@end
