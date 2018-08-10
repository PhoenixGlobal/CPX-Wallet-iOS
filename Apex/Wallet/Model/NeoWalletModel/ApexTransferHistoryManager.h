//
//  ApexTransferHistoryManager.h
//  Apex
//
//  Created by chinapex on 2018/6/22.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

//交易状态改变的通知
#define Notification_TranferStatusHasChanged @"Notification_TranferStatusHasChanged"
#define Notification_TranferHasConfirmed @"Notification_TranferHasConfirmed"

@class ApexTransferModel;

@interface ApexTransferHistoryManager : NSObject
singleH(Manager);
- (void)createTableForWallet:(NSString*)walletAddress;
- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString*)walletAddress;
- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString*)txid ofWallet:(NSString*)walletAddress;
- (NSMutableArray*)getAllTransferHistoryForAddress:(NSString*)address;

//获取资产id前缀为prefix的记录
- (NSMutableArray*)getHistoryiesWithPrefixOfTxid:(NSString*)prefix address:(NSString*)address;
//获取id区间内的历史记录
- (NSMutableArray*)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString*)address;
//获取id最后一条记录
- (ApexTransferModel*)getLastTransferHistoryOfAddress:(NSString*)address;
//应用启动自检测
- (void)applicationIntializeSelfCheckWithAddress:(NSString*)address;

- (void)beginTimerToConfirmTransactionOfAddress:(NSString*)address txModel:(ApexTransferModel*)model; /**< 轮询获取此交易状态 */

//用户在打开钱包时进行历史记录的更新
- (void)secreteUpdateUserTransactionHistoryAddress:(NSString*)address;

- (void)requestTxHistoryForAddress:(NSString*)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure;
@end
