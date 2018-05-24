//
//  ApexWalletManager.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWalletManager.h"

@implementation ApexWalletManager
+ (void)saveWallet:(NSString *)wallet{
    NSMutableArray *arr = [TKFileManager loadDataWithFileName:walletsKey];
    if (!arr) {
        arr = [NSMutableArray array];
    }
    
    [arr addObject:wallet];
    [TKFileManager saveData:arr withFileName:walletsKey];
}

+ (void)changeWalletName:(NSString*)name forAddress:(NSString*)address{
    [self deleteWalletForAddress:address];
    [self saveWallet:[NSString stringWithFormat:@"%@/%@",address, name]];
}

+ (id)getWalletsArr{
    return [TKFileManager loadDataWithFileName:walletsKey];
}

+ (void)deleteWalletForAddress:(NSString *)address{
    NSMutableArray *arr = [self getWalletsArr];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:arr];
    
    for (NSString *wallet in temp) {
        if ([wallet containsString:address]) {
            [arr removeObject:wallet];
            break;
        }
    }
    [TKFileManager saveData:arr withFileName:walletsKey];
}

+ (void)getAccountStateWithAddress:(NSString *)address Success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    [[ApexRPCClient shareRPCClient] invokeMethod:@"getaccountstate" withParameters:@[address] success:success failure:failure];
}

+ (void)getRawTransactionWithTxid:(NSString *)txid Success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    [[ApexRPCClient shareRPCClient] invokeMethod:@"getrawtransaction" withParameters:@[txid,@1] success:success failure:failure];
}

+ (void)broadCastTransactionWithData:(NSString *)data Success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    [[ApexRPCClient shareRPCClient] invokeMethod:@"sendrawtransaction" withParameters:@[data] success:success failure:failure];
}
@end
