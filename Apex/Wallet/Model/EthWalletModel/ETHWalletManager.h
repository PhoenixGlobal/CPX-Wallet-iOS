//
//  ETHWalletManager.h
//  eth_test
//
//  Created by yulin chi on 2018/8/2.
//  Copyright © 2018年 yulin chi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Tool.h"
#import "SystemConvert.h"
#import "ApexWalletManagerProtocal.h"

@class ETHWalletModel;

@interface ETHWalletManager : NSObject<ApexWalletManagerProtocal>
singleH(Manager);
//创建钱包
+ (void)creatETHWalletSuccess:(void (^)(EthmobileWallet *wallet))success failed:(void (^)(NSError *error))fail;

//发送交易
+ (void)sendTxWithWallet:(EthmobileWallet*)wallet to:(NSString*)to nonce:(NSString*)nonce amount:(NSString*)amount gas:(NSString*)gas
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**erc20 交易  原始金额不用乘以精度*/
+ (void)sendERC20TxWithWallet:(EthmobileWallet*)wallet contractAddress:(NSString*)contract to:(NSString*)to nonce:(NSString*)nonce amount:(NSString*)amount gas:(NSString*)gas assetModel:(ApexAssetModel*)assetModel
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取交易详情
+ (void)requestTransactionByHash:(NSString*)hash
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取nonce
+ (void)requestTransactionCount:(NSString*)address
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取交易收据,pending中的交易返回nil
/**
    交易上链后才会有返回
 */
+ (void)requestTransactionReceiptByHash:(NSString*)hash
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//获取以太币资产
+ (void)requestETHBalanceOfAddress:(NSString *)address
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取当前块数
+ (void)requestCurrentBlockNumberSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//查询erc20资产
+ (void)requestERC20BalanceOfContract:(NSString*)contract Address:(NSString*)address decimal:(NSString*)decimal
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取当前的gas价格
+ (void)getCurrentGasPrice:(void (^)(NSString *gasPriceInWei))successBlock fail:(void (^)(NSError *error))failBlock;
//估算交易需要gas
//+ (void)requestERC20TransferGasNeeded:(NSString*)contract to:(NSString*)to value:(NSString*)valueNoDecimal
//                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
