//
//  ApexTransHistoryProtocal.h
//  Apex
//
//  Created by yulin chi on 2018/8/15.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ApexTransferModel;
//交易状态改变的通知
#define Notification_TranferStatusHasChanged @"Notification_TranferStatusHasChanged"
#define Notification_TranferHasConfirmed @"Notification_TranferHasConfirmed"

@protocol ApexTransHistoryProtocal <NSObject>
- (void)createTableForWallet:(NSString*)walletAddress;
- (void)addTransferHistory:(id)model forWallet:(NSString*)walletAddress;
- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString*)txid ofWallet:(NSString*)walletAddress;
- (NSMutableArray*)getAllTransferHistoryForAddress:(NSString*)address;

//获取资产id前缀为prefix的记录
- (NSMutableArray*)getHistoryiesWithPrefixOfTxid:(NSString*)prefix address:(NSString*)address;
//获取id区间内的历史记录
- (NSMutableArray*)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString*)address;
//获取id最后一条记录
- (id)getLastTransferHistoryOfAddress:(NSString*)address;
- (NSArray*)getTransferHistoriesFromEndWithLimit:(NSString*)limite address:(NSString*)address;

//应用启动自检测
- (void)applicationIntializeSelfCheckWithAddress:(NSString*)address;

- (void)beginTimerToConfirmTransactionOfAddress:(NSString*)address txModel:(ApexTransferModel*)model; /**< 轮询获取此交易状态 */

//用户在打开钱包时进行历史记录的更新
- (void)secreteUpdateUserTransactionHistoryAddress:(NSString*)address;

//请求钱包交易历史
- (void)requestTxHistoryForAddress:(NSString*)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure;
@end
