//
//  ApexWalletManager.h
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApexWalletManagerProtocal.h"

@class ApexWalletModel;
@class BalanceObject;

@interface ApexWalletManager : NSObject<ApexWalletManagerProtocal>
singleH(Manager);
/** 获取钱包余额 */
+ (void)getAccountStateWithAddress:(NSString*)address Success:(void (^)(AFHTTPRequestOperation  *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** 获取钱包的转账记录*/

/**获取nep5资产余额 返回BalanceObject实例*/
+ (void)getNep5AssetAccountStateWithAddress:(NSString*)address andAssetId:(NSString*)assetId  Success:(void (^)(AFHTTPRequestOperation  *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**获取资产symbol*/
+ (void)getAssetSymbol:(NSString*)assetId Success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

/** 获取交易明细 */
+ (void)getRawTransactionWithTxid:(NSString*)txid Success:(void (^)(AFHTTPRequestOperation  *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** 验证是否neo有效地址 */
+ (void)verifyIsValideNeoAddress:(NSString*)address success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** 获取交易历史记录*/
//+ (void)getTransactionHistoryWithAddress:(NSString*)addr BeginTime:(NSTimeInterval)beginTime Success:(void (^)(CYLResponse  *response))success failure:(void (^)(NSError *error))failure;

/** 广播交易 */
+ (void)broadCastTransactionWithData:(NSString*)data Success:(void (^)(AFHTTPRequestOperation  *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



@end
