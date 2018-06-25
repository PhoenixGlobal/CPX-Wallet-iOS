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

@class ApexTransferModel;

@interface ApexTransferHistoryManager : NSObject
singleH(Manager);
- (void)createTableForWallet:(NSString*)walletAddress;
- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString*)walletAddress;
- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString*)txid ofWallet:(NSString*)walletAddress;
- (NSMutableArray*)getAllTransferHistoryForAddress:(NSString*)address;

- (void)beginTimerToConfirmTransactionOfAddress:(NSString*)address txModel:(ApexTransferModel*)model; /**< 轮询获取此交易状态 */
- (void)requestTxHistoryForAddress:(NSString*)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure;
@end
