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

#define ethWalletsKey @"ethWalletsKey"

@implementation ETHWalletManager
singleM(Manager);
#pragma mark - public
- (ETHWalletModel*)saveWallet:(NSString *)address name:(NSString *)name{
    NSMutableArray *ethArr = [TKFileManager loadDataWithFileName:ethWalletsKey];
    if (!ethArr) {
        ethArr = [NSMutableArray array];
    }
    //删除已有的
    NSNumber *timeStampIfHave = nil;
    for (ETHWalletModel *wallet in ethArr) {
        if ([wallet.address isEqualToString:address]) {
            timeStampIfHave = wallet.createTimeStamp;
            [ethArr removeObject:wallet];
            break;
        }
    }
    
    //添加新的
    ETHWalletModel *wallet = [[ETHWalletModel alloc] init];
    wallet.address = address;
    name == nil ? (wallet.name = @"Wallet") : (wallet.name = name);
    wallet.isBackUp = false;
    wallet.assetArr = [self setDefultAsset];
    wallet.createTimeStamp = timeStampIfHave == nil ? @([[NSDate date] timeIntervalSince1970]) : timeStampIfHave;
    wallet.canTransfer = @(YES);
//    [[ApexTransferHistoryManager shareManager] createTableForWallet:model.address];
    [ethArr addObject:wallet];
    [TKFileManager saveData:ethArr withFileName:ethWalletsKey];
    [TKFileManager saveValue:@(YES) forKey:KisFirstCreateWalletDone];
    
    return wallet;
}

- (NSMutableArray*)setDefultAsset{
    NSMutableArray *arr = [NSMutableArray array];
    BalanceObject *Eth = [[BalanceObject alloc] init];
    Eth.asset = assetId_Eth;
    Eth.value = @"0";
    [arr addObject:Eth];
    
    //test erc20
    BalanceObject *nmb = [[BalanceObject alloc] init];
    nmb.asset = assetID_Test_Erc20;
    nmb.value = @"0";
    [arr addObject:nmb];
    
    return arr;
}

- (NSMutableArray*)getWalletsArr{
    return [[[TKFileManager loadDataWithFileName:ethWalletsKey] sortedArrayUsingComparator:^NSComparisonResult(ETHWalletModel *obj1, ETHWalletModel *obj2) {
        return obj1.createTimeStamp.integerValue > obj2.createTimeStamp.integerValue;
    }] mutableCopy];
}

- (void)changeWalletName:(NSString *)name forAddress:(NSString *)address {
    [self saveWallet:address name:name];
}


- (void)deleteWalletForAddress:(NSString *)address {
    NSMutableArray *arr = [self getWalletsArr];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:arr];
    
    for (ETHWalletModel *wallet in temp) {
        if ([wallet.address containsString:address]) {
            [arr removeObject:wallet];
            break;
        }
    }
    [TKFileManager saveData:arr withFileName:ethWalletsKey];
}


- (BOOL)getWalletTransferStatusForAddress:(NSString *)address {
    NSArray *arr = [self getWalletsArr];
    for (ETHWalletModel *wallet in arr) {
        if ([wallet.address isEqualToString:address]) {
            return wallet.canTransfer;
        }
    }
    return NO;
}


- (void)setBackupFinished:(NSString *)address {
    NSArray *arr = [self getWalletsArr];
    for (ETHWalletModel *model in arr) {
        if ([model.address isEqualToString:address]) {
            model.isBackUp = YES;
        }
    }
    [TKFileManager saveData:arr withFileName:ethWalletsKey];
}


- (void)setStatus:(BOOL)status forWallet:(NSString *)address {
    NSArray *arr = [self getWalletsArr];
    for (ETHWalletModel *wallet in arr) {
        if ([wallet.address isEqualToString:address]) {
            wallet.canTransfer = status;
            break;
        }
    }
    [TKFileManager saveData:arr withFileName:ethWalletsKey];
}


- (ApexTransferStatus)transferStatusForAddress:(NSString *)address {
    return 0;
}


- (void)updateWallet:(id)wallet WithAssetsArr:(NSMutableArray<BalanceObject *> *)assetArr {
    ETHWalletModel *model = (ETHWalletModel*)wallet;
    [self deleteWalletForAddress:model.address];
    NSMutableArray *arr = [TKFileManager loadDataWithFileName:ethWalletsKey];
    [self reSortAssetArr:assetArr];
    model.assetArr = assetArr;
    [arr addObject:model];
    [TKFileManager saveData:arr withFileName:ethWalletsKey];
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

- (void)reSortAssetArr:(NSMutableArray*)assetArr{
    BalanceObject *eth = nil;
    
    for (BalanceObject *obj in [assetArr copy]) {
        if ([assetId_Eth containsString:obj.asset]) {
            eth = obj;
            [assetArr removeObject:obj];
            break;
        }
    }
    
    [assetArr sortUsingComparator:^NSComparisonResult(BalanceObject *obj1, BalanceObject *obj2) {
        return [obj1.asset compare:obj2.asset] == NSOrderedAscending;
    }];
    
    if (eth) {
        [assetArr insertObject:eth atIndex:0];
    }
}


- (void)WalletFromKeystore:(NSString *)ks password:(NSString *)passWord success:(void (^)(id))success failed:(void (^)(NSError *))failed{
    NSError *err = nil;
    id wallet = nil;
    wallet = EthmobileFromKeyStore(ks, passWord, &err);
    if (!err && wallet) {
        success(wallet);
    }else{
        failed(err);
    }
}

- (ApexAssetModel *)assetModelByBalanceModel:(BalanceObject *)balanceObj{
    
    ApexAssetModel *model = nil;
    if ([balanceObj.asset isEqualToString:assetId_Eth]) {
        model = [ApexAssetModel new];
        model.hex_hash = assetId_Eth;
        model.symbol = @"ETH";
        model.precision = @"18";
        model.type = @"erc20";
        model.name = @"ETH";
    }else{
        for (ApexAssetModel *assModel in [ETHAssetModelManage getLocalAssetModelsArr]) {
            if ([model.hex_hash isEqualToString:balanceObj.asset]) {
                model = assModel;
            }
        }
    }
    
    return model;
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

+ (void)sendERC20TxWithWallet:(EthmobileWallet*)wallet contractAddress:(NSString*)contract to:(NSString*)to nonce:(NSString*)nonce amount:(NSString*)amount gas:(NSString*)gas assetModel:(ApexAssetModel*)assetModel
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    
    long long transfer = amount.doubleValue * pow(10, assetModel.precision.integerValue);
    NSString *transferStr = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:transfer]];
    NSString *gasStr = [NSString DecimalFuncWithOperatorType:2 first:gas secend:@"1000000000000000000" value:10];
    gasStr = [NSString DecimalFuncWithOperatorType:3 first:gasStr secend:@"90000" value:8];
    gasStr = [NSString stringWithFormat:@"0x%@",[SystemConvert decimalToHex:gasStr.integerValue]];
    NSString *gasLimits = @"0x15f90";
    NSError *err = nil;
    NSString *tx = [wallet transferERC20:contract nonce:nonce to:to amount:transferStr gasPrice:gasStr gasLimits:gasLimits error:&err];
    if (![tx hasPrefix:@"0x"]) {
        tx = [NSString stringWithFormat:@"0x%@",tx];
    }
    
    if (err&&failure) {
        failure(nil,err);
    }
    
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

+ (void)requestERC20TransferGasNeeded:(NSString*)contract to:(NSString*)to value:(NSString*)valueNoDecimal
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    //{"jsonrpc":"2.0","method":"eth_estimateGas","params":[{"to":"0x7a6542e629630a6a2c89ccce098386dcec39f6cf", "data":"0x9d61d2340000000000000000000000003f5ce5fbfe3e9af3971dd833d26ba9b5c936f0be0000000000000000000000000000000000000000000000017a83e90a984d4000"}],"id":1}
    NSString *methodID = @"0x9d61d234";
    NSString *valueHex = [NSString addString:@"0" Length:64 OnString:[NSString ToHex:valueNoDecimal]];
    if([to hasPrefix:@"0x"]) to = [to stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    to = [NSString addString:@"0" Length:64 OnString:to];
    NSMutableString *data = [NSMutableString stringWithString:methodID];
    [data appendString:to];
    [data appendString:valueHex];
    
    [[ApexETHClient shareRPCClient] invokeMethod:@"eth_estimateGas" withParameters:@[@{@"to":contract,@"data":data}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        long long gasPrice = 3 * powl(10, 9);
        NSString *hexGas = responseObject;
        NSScanner *scanner = [NSScanner scannerWithString:hexGas];
        unsigned long long gasUsed = 0;
        [scanner scanHexLongLong:&gasUsed];
        NSString *totalGas = @(gasUsed * gasPrice).stringValue;
        NSString *etherUsed = [NSString DecimalFuncWithOperatorType:3 first:totalGas secend:@"1000000000000000000" value:0];
        
        if (success) {
            success(operation,etherUsed);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
    
}


//+ (void)ethCallMethodString:(NSString*)methodHexId to:(NSString*)to extraArg:(NSString*)extro DataArgs:(NSString*)arg1, ... NS_REQUIRES_NIL_TERMINATION {
//    
//    NSMutableArray *argArr = [NSMutableArray array];
//    if(arg1){
//        arg1 = [NSString ToHex:arg1];
//        [argArr addObject:[NSString addString:@"0" Length:64 OnString:arg1]];
//        //定义可变参数列表指针
//        va_list args;
//        //定义可变参数指针
//        NSString *arg;
//        //可变参数列表指针指向第一个参数
//        va_start(args, arg1);
//        //获取第一个之后的参数
//        while((arg = va_arg(args, NSString*))){
//            arg = [NSString ToHex:arg];
//            [argArr addObject:[NSString addString:@"0" Length:64 OnString:arg]];
//        }
//    }
//    
//    NSMutableString *data = [NSMutableString stringWithString:methodHexId];
//    [data appendString:[argArr componentsJoinedByString:@""]];
//    
//}

+ (void)requestTransactionCount:(NSString*)address
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    //{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["0xc94770007dda54cF92009BFF0dE90c06F603a09f","latest"],"id":1}
    [[ApexETHClient shareRPCClient] invokeMethod:@"eth_getTransactionCount" withParameters:@[address,@"latest"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSScanner *scanner = [[NSScanner alloc] initWithString:responseObject];
            unsigned long long i = 0;
            [scanner scanHexLongLong:&i];
            success(operation,@(i));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
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

+ (void)requestETHBalanceOfAddress:(NSString *)address
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    //{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xc94770007dda54cF92009BFF0dE90c06F603a09f", "latest"],"id":1}
    [[ApexETHClient shareRPCClient] invokeMethod:@"eth_getBalance" withParameters:@[address,@"latest"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSScanner *scanner = [NSScanner scannerWithString:responseObject];
            unsigned long long i = 0;
            [scanner scanHexLongLong:&i];
            success(operation,[NSString DecimalFuncWithOperatorType:3 first:@(i).stringValue secend:@"1000000000000000000" value:0]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
}

+ (void)requestERC20BalanceOfContract:(NSString*)contract Address:(NSString*)address
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    //{"jsonrpc":"2.0","method":"eth_call","params"[{"to":"0x123ab195dd38b1b40510d467a6a359b201af056f","data":"0x70a082310000000000000000000000008afCE0B7CA212fcD4FD9EA54749c6c48e715c60f"},"latest"],"id":1}
    NSError *err = nil;
    NSString *data = [[EthmobileEthCall new] balanceOf:contract address:address error:&err];
    if (err && failure) {
        failure(nil, err);
        return;
    }
    NSData *d = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",data);
    [[ApexETHClient shareRPCClient] invokeMethod:@"eth_call" withParameters:@[dict,@"latest"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            
            NSScanner *scanner = [NSScanner scannerWithString:responseObject];
            unsigned long long i = 0;
            [scanner scanHexLongLong:&i];
            NSLog(@"%@",[SystemConvert hexToDecimal:responseObject]);
            success(operation,@(i));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
    
}
@end
