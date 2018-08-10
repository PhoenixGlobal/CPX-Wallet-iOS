//
//  ETHWalletManager.m
//  eth_test
//
//  Created by yulin chi on 2018/8/2.
//  Copyright © 2018年 yulin chi. All rights reserved.
//

#import "ETHWalletManager.h"

@implementation ETHWalletManager
+ (void)creatETHWalletSuccess:(void (^)(EthmobileWallet *))success failed:(void (^)(NSError *))fail{
    NSError *error = nil;
    EthmobileWallet *wallet = EthmobileNew(&error);
    if (error) {
        fail(error);
    }else{
        success(wallet);
    }
}

+ (void)sendTxWithWallet:(EthmobileWallet*)wallet to:(NSString*)to nonce:(NSString*)nonce amount:(NSString*)amount gas:(NSString*)gas Success:(void (^)(NSString *))success failed:(void (^)(NSError *))fail{
    long long transfer = amount.doubleValue * pow(10, 18);
    NSString *amountTrans = [NSString stringWithFormat:@"0x%@", [SystemConvert decimalToHex:transfer]];;
    NSString *gasStr = [NSString DecimalFuncWithOperatorType:3 first:gas secend:@"90000" value:18];
    gasStr = [NSString DecimalFuncWithOperatorType:2 first:gasStr secend:@"1000000000000000000" value:0];
    NSString * gasPrice = [SystemConvert decimalToHex:gasStr.integerValue];
    gasPrice = [NSString stringWithFormat:@"0x%@", [gasPrice lowercaseString]];
    
    NSString *gasLimits = @"0x15f90";
    NSError *err = nil;
    NSString *tx = [wallet transfer:nonce to:to amount:amountTrans gasPrice:gasPrice gasLimits:gasLimits error:&err];
    
    if (success) {
        success(tx);
    }
    
    if (fail) {
        fail(err);
    }
    
    NSLog(@"%@",tx);
}

+ (void)requestETHBalanceOfAddress:(NSString *)address success:(void (^)(NSString *))success failed:(void (^)(NSError *))failed{
    
}
@end
