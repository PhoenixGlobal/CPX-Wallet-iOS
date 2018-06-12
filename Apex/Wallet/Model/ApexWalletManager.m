//
//  ApexWalletManager.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWalletManager.h"
#import "ApexWalletModel.h"

@implementation ApexWalletManager
+ (void)saveWallet:(NSString *)wallet{
    NSMutableArray *arr = [TKFileManager loadDataWithFileName:walletsKey];
    if (!arr) {
        arr = [NSMutableArray array];
    }
    NSArray *array = [wallet componentsSeparatedByString:@"/"];
    ApexWalletModel *model = [[ApexWalletModel alloc] init];
    model.name = array.lastObject;
    model.address = array.firstObject;
    model.isBackUp = false;
    model.assetArr = [self setDefultAsset];
    model.createTimeStamp = @([[NSDate date] timeIntervalSince1970]);
    [arr addObject:model];
    [TKFileManager saveData:arr withFileName:walletsKey];
}

+ (void)updateWallet:(ApexWalletModel*)wallet WithAssetsArr:(NSMutableArray*)assetArr{
    [self deleteWalletForAddress:wallet.address];
    NSMutableArray *arr = [TKFileManager loadDataWithFileName:walletsKey];
    wallet.assetArr = assetArr;
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
    
    for (ApexWalletModel *wallet in temp) {
        if ([wallet.address containsString:address]) {
            [arr removeObject:wallet];
            break;
        }
    }
    [TKFileManager saveData:arr withFileName:walletsKey];
}

+ (void)setBackupFinished:(NSString*)address{
    NSArray *arr = [self getWalletsArr];
    for (ApexWalletModel *model in arr) {
        if ([model.address isEqualToString:address]) {
            model.isBackUp = YES;
        }
    }
    [TKFileManager saveData:arr withFileName:walletsKey];
}

+ (NSMutableArray*)setDefultAsset{
    NSMutableArray *arr = [NSMutableArray array];
    BalanceObject *cpx = [[BalanceObject alloc] init];
    cpx.asset = assetId_CPX;
    cpx.value = @"0.0";
    [arr addObject:cpx];
    return arr;
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
