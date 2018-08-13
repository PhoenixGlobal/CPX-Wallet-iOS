//
//  ETHWalletManager.m
//  eth_test
//
//  Created by yulin chi on 2018/8/2.
//  Copyright © 2018年 yulin chi. All rights reserved.
//

#import "ETHWalletManager.h"
#import "ApexETHClient.h"
#import "ApexETHTransactionModel.h"
#import "ETHWalletModel.h"

@implementation ETHWalletManager
#pragma mark - public
+ (void)saveETHWallet:(NSString *)address name:(NSString *)name{
    NSMutableArray *ethArr = [TKFileManager loadDataWithFileName:ethWalletsKey];
    if (!ethArr) {
        ethArr = [NSMutableArray array];
    }
    ETHWalletModel *wallet = [[ETHWalletModel alloc] init];
    wallet.address = address;
    name == nil ? (wallet.name = @"Wallet") : (wallet.name = name);
    wallet.isBackUp = false;
//    wallet.assetArr = [self setDefultAsset];
    wallet.createTimeStamp = @([[NSDate date] timeIntervalSince1970]);
    wallet.canTransfer = @(YES);
//    [[ApexTransferHistoryManager shareManager] createTableForWallet:model.address];
    [ethArr addObject:wallet];
    [TKFileManager saveData:ethArr withFileName:ethWalletsKey];
    [TKFileManager saveValue:@(YES) forKey:KisFirstCreateWalletDone];
}

+ (NSMutableArray*)getEthWalletsArray{
    return [[[TKFileManager loadDataWithFileName:ethWalletsKey] sortedArrayUsingComparator:^NSComparisonResult(ETHWalletModel *obj1, ETHWalletModel *obj2) {
        return obj1.createTimeStamp.integerValue > obj2.createTimeStamp.integerValue;
    }] mutableCopy];
}

+ (void)creatETHWalletSuccess:(void (^)(EthmobileWallet *))success failed:(void (^)(NSError *))fail{
    NSError *error = nil;
    EthmobileWallet *wallet = EthmobileNew(&error);
    if (error) {
        fail(error);
    }else{
        success(wallet);
    }
}


#pragma mark - request
+ (void)sendTxWithWallet:(EthmobileWallet*)wallet to:(NSString*)to nonce:(NSString*)nonce amount:(NSString*)amount gas:(NSString*)gas
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    long long transfer = amount.doubleValue * pow(10, 18);
    NSString *amountTrans = [NSString stringWithFormat:@"0x%@", [SystemConvert decimalToHex:transfer]];;
    NSString *gasStr = [NSString DecimalFuncWithOperatorType:3 first:gas secend:@"90000" value:18];
    gasStr = [NSString DecimalFuncWithOperatorType:2 first:gasStr secend:@"1000000000000000000" value:0];
    NSString * gasPrice = [SystemConvert decimalToHex:gasStr.integerValue];
    gasPrice = [NSString stringWithFormat:@"0x%@", [gasPrice lowercaseString]];
    
    NSString *gasLimits = @"0x15f90";
    NSError *err = nil;
    NSString *tx = [wallet transfer:nonce to:to amount:amountTrans gasPrice:gasPrice gasLimits:gasLimits error:&err];
    if (![tx hasPrefix:@"0x"]) {
        tx = [NSString stringWithFormat:@"0x%@",tx];
    }
    NSLog(@"ETH_TXN: %@",tx);
    
    //{"jsonrpc":"2.0","method":"eth_sendRawTransaction","params":[{see above}],"id":1}
    [[ApexETHClient shareRPCClient] invokeMethod:@"eth_sendRawTransaction" withParameters:@[tx] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (void)requestTransactionByHash:(NSString*)hash
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    //{"jsonrpc":"2.0","method":"eth_getTransactionByHash","params":["0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"],"id":1}
    [[ApexETHClient shareRPCClient] invokeMethod:@"eth_getTransactionByHash" withParameters:@[hash] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            ApexETHTransactionModel *model = [ApexETHTransactionModel yy_modelWithDictionary:responseObject];
            success(operation,model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (void)requestTransactionReceiptByHash:(NSString *)hash success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    //{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["0xdaa3205ab50bade7815a0719202250731d2332cbbaa81fd05a92469da1ef3490"],"id":1}
    [[ApexETHClient shareRPCClient] invokeMethod:@"eth_getTransactionReceipt" withParameters:@[hash] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            ApexETHReceiptModel *model = [ApexETHReceiptModel yy_modelWithDictionary:responseObject];
            success(operation,model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}

+ (void)requestERC20TransactionByHash:(NSString*)hash
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
//
}

+ (void)requestETHBalanceOfAddress:(NSString *)address
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    //{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xc94770007dda54cF92009BFF0dE90c06F603a09f", "latest"],"id":1}
    [[ApexETHClient shareRPCClient] invokeMethod:@"eth_getBalance" withParameters:@[address,@"latest"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}
@end
