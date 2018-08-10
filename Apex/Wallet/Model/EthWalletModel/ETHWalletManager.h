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

#define apiToken @"CTTVCEUHGU1UMY14IMWH5G9IREY7AAMT1V"

@interface ETHWalletManager : NSObject
+ (void)creatETHWalletSuccess:(void (^)(EthmobileWallet *wallet))success failed:(void (^)(NSError *error))fail;

+ (void)sendTxWithWallet:(EthmobileWallet*)wallet to:(NSString*)to nonce:(NSString*)nonce amount:(NSString*)amount gas:(NSString*)gas Success:(void (^)(NSString *))success failed:(void (^)(NSError *))fail;

+ (void)requestETHBalanceOfAddress:(NSString*)address success:(void (^)(NSString *balance))success failed:(void (^)(NSError *err))failed;
@end
