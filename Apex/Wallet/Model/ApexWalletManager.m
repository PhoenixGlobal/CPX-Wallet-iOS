//
//  ApexWalletManager.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWalletManager.h"
#import "ApexWalletModel.h"

//交易状态模型
@interface ApexTransferStatusModel : NSObject
@property (nonatomic, assign) ApexTransferStatus status; /**< 此笔交易的状态 */
@property (nonatomic, assign) NSInteger transferAtHeight; /**< 此笔交易所在的区块高度 */
@end

@implementation ApexAccountStateModel

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//钱包管理模型
@interface ApexWalletManager()
@property (nonatomic, strong) NSMutableDictionary<NSString*, ApexTransferStatusModel*> *transferStatusDict;
@end

@implementation ApexWalletManager

singleM(Manager);

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

+ (void)updateWallet:(ApexWalletModel*)wallet WithAssetsArr:(NSMutableArray<BalanceObject*>*)assetArr{
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

+ (void)getNep5AssetAccountStateWithAddress:(NSString *)address andAssetId:(NSString *)assetId Success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    //先获取资产的精度
    [self getAssetDicimalWithAssetId:assetId Success:^(AFHTTPRequestOperation *operation, id resp) {
        //再获取nep5资产
        NSArray *stack = resp[@"stack"];
        NSDictionary *balanceDic = stack.firstObject;
        NSString *dicimal = balanceDic[@"value"];
        
        NSError *err = nil;
        NSString *encodeAddress = NeomobileDecodeAddress(address, &err);
        if (err) {
            failure(operation, [NSError new]);
            return;
        }
        NSArray *param = @[
                           assetId,
                           @"balanceOf",
                           @[
                            @{
                                @"type": @"Hash160",
                                @"value": encodeAddress
                        }
                        ]
                           ];
        
        [[ApexRPCClient shareRPCClient] invokeMethod:@"invokefunction" withParameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *stack = responseObject[@"stack"];
            NSDictionary *balanceDic = stack.firstObject;
            NSString *value = balanceDic[@"value"];
            NSData *data = [self convertHexStrToData:value];
            
            BalanceObject *balanceOBJ = [BalanceObject new];
            balanceOBJ.asset = assetId;
            if (value.length != 0) {
                NSString *balance = [NSString stringWithFormat:@"%lf", [self getBalanceWithByte:(Byte *)data.bytes length:data.length] / pow(10, dicimal.doubleValue)];
                balanceOBJ.value = balance;
            }else{
                balanceOBJ.value = @"0.0";
            }
            success(operation,balanceOBJ);
        } failure:failure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *err) {
        failure(operation,err);
    }];
    
}

+ (void)getAssetDicimalWithAssetId:(NSString*)assetid Success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    if (![assetid hasPrefix:@"0x"]) {
        assetid = [NSString stringWithFormat:@"0x%@",assetid];
    }
    NSArray *param = @[
                      assetid,
                      @"decimals",
                      @[]
                      ];
    [[ApexRPCClient shareRPCClient] invokeMethod:@"invokefunction" withParameters:param success:success failure:failure];
}

+ (void)getAssetSymbol:(NSString*)assetId Success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSArray *param = @[
                      assetId,
                      @"symbol",
                      @[]
                      ];
    
    [[ApexRPCClient shareRPCClient] invokeMethod:@"invokefunction" withParameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *stack = responseObject[@"stack"];
        NSDictionary *balanceDic = stack.firstObject;
        NSString *value = balanceDic[@"value"];
        NSString *symbol = [[NSString alloc] initWithData:[self convertHexStrToData:value] encoding:NSUTF8StringEncoding];
        success(operation, symbol);
    } failure:failure];
}


#pragma mark - ------tools------

+ (void)setTransferStatus:(ApexTransferStatus)status forAddress:(NSString*)address{
    ApexWalletManager *Manager = [ApexWalletManager shareManager];
    if (![Manager.transferStatusDict.allKeys containsObject:address]) {
        ApexTransferStatusModel *model = [ApexTransferStatusModel new];
        model.status = status;
        
    }else{
        ApexTransferStatusModel *model = Manager.transferStatusDict[address];
        model.status = status;
    }
}

/**
 将16进制的字符串转换成NSData
 */
+ (NSData *)convertHexStrToData:(NSString *)str {
    NSString *balance = [NSString stringWithFormat:@"%@", str];
    if (!balance || [balance length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([balance length] %2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [balance length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [balance substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return [hexData copy];
}

/**
 byte转换成余额
 */
+ (unsigned long long)getBalanceWithByte:(Byte *)byte length:(NSInteger)length {
    Byte newByte[length];
    for (NSInteger i = 0; i < length; i++) {
        newByte[i] = byte[length - i - 1];
    }
    
    NSString *hexStr = @"";
    for(int i=0;i < length;i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",newByte[i]&0xff]; // 16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    NSScanner * scanner = [NSScanner scannerWithString:hexStr];
    
    unsigned long long balance;
    
    [scanner scanHexLongLong:&balance];
    
    return balance;
}


#pragma mark - ------getter------
- (NSMutableDictionary<NSString *,ApexTransferStatusModel *> *)transferStatusDict{
    if (!_transferStatusDict) {
        _transferStatusDict = [NSMutableDictionary dictionary];
    }
    return _transferStatusDict;
}
@end
