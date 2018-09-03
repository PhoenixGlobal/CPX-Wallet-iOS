//
//  ETHTransferHistoryManager.m
//  Apex
//
//  Created by yulin chi on 2018/8/15.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ETHTransferHistoryManager.h"
#import <FMDB.h>
#import "ApexTransferModel.h"
#import "ApexETHTransactionModel.h"
#import "ApexTransHistoryDataBaseHelper.h"

#define timerInterval 10.0
#define confirmHeight 3

@interface ETHTransferHistoryManager()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ETHTransferHistoryManager
#pragma mark - ------singleton-----
// 创建静态对象 防止外部访问
static ETHTransferHistoryManager *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            [_instance initDataBase];
        }
    });
    return _instance;
}

+(instancetype)shareManager
{
    return [[self alloc]init];
}

-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

#pragma mark - ------private-----
- (void)initDataBase{
    _db = [[ApexTransHistoryDataBaseHelper shareDataBase] dataBaseWithManager:self];
}

- (void)createTableForWallet:(NSString *)walletAddress {
    [[ApexTransHistoryDataBaseHelper shareDataBase] createTableForWallet:walletAddress manager:self successCreated:^{
        [self requestTxHistoryForAddress:walletAddress Success:^(CYLResponse *res) {
        } failure:^(NSError *err) {
        }];
    }];
}

- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString *)walletAddress {
    [[ApexTransHistoryDataBaseHelper shareDataBase] addTransferHistory:model forWallet:walletAddress manager:self];
}

- (void)applicationIntializeSelfCheckWithAddress:(NSString *)address {
    ApexTransferModel *last = [self getLastTransferHistoryOfAddress:address];
    if (last == nil) return;
    if (last.status == ApexTransferStatus_Blocking || last.status == ApexTransferStatus_Progressing) {
        //开启循环更新状态
        [self beginTimerToConfirmTransactionOfAddress:address txModel:last];
    }else{
        [[ApexWalletManager shareManager] setStatus:YES forWallet:address];
    }
}

- (void)beginTimerToConfirmTransactionOfAddress:(NSString *)address txModel:(ApexTransferModel *)model {
    if (model.status == ApexTransferStatus_Blocking) {
        [[ApexWalletManager shareManager] setStatus:NO forWallet:address];
    }
    
    __block BOOL cancleTimer = false;
    NSTimer *aTimer = [NSTimer timerWithTimeInterval:timerInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (cancleTimer) {
            return;
        }
        
        //与neo此处的处理不同, 交易上链后才有返回,否则返回nil
        [ETHWalletManager requestTransactionReceiptByHash:model.txid success:^(AFHTTPRequestOperation *operation, ApexETHReceiptModel *responseObject) {
            if (responseObject.status && responseObject.status.integerValue == 1) {
                //交易上链成功
            }else if(responseObject.status && responseObject.status.integerValue == 0){
                //交易失败
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
//        [[ApexTransferHistoryManager shareManager] requestBlockHeightWithTxid:model.txid success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//            NSDictionary *dict = (NSDictionary*)responseObject;
//            if ([dict.allKeys containsObject:@"confirmations"]) {
//                //交易确认中
//                [self updateTransferStatus:ApexTransferStatus_Progressing forTXID:model.txid ofWallet:address];
//                NSInteger confirmations = ((NSString*)dict[@"confirmations"]).integerValue;
//
//                NSLog(@"%@", [NSString stringWithFormat:@"交易上链,confirmations:%ld",confirmations]);
//
//                if (confirmations >= confirmHeight) {
//
//                    //交易成功
//                    [[ApexWalletManager shareManager] setStatus:YES forWallet:address];
//                    [self.db open];
//                    [self.db executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET state = ?  WHERE txid = ? ",address],@(ApexTransferStatus_Confirmed),model.txid];
//                    [self.db close];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TranferHasConfirmed object:@""];
//                    cancleTimer = true;
//                    [timer invalidate];
//                }else{
//                    //确认中
//                    //设置钱包状态不可交易
//                    [[ApexWalletManager shareManager] setStatus:NO forWallet:address];
//                }
//            }
//
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        }];
    }];
    
    [[ApexThread shareInstance].threadRunLoop addTimer:aTimer forMode:NSRunLoopCommonModes];
    [aTimer fire];
}

- (NSMutableArray *)getAllTransferHistoryForAddress:(NSString *)address {
    [_db open];
    address = [self encodeAddress:address];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC",address]];
    while ([res next]) {
        ApexTransferModel *model = [self buildModelWithResult:res];
        [dataArray addObject:model];
    }
    [_db close];
    return dataArray;
}

- (NSMutableArray *)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString *)address {
    [_db open];
    address = [self encodeAddress:address];
    NSMutableArray *temp = [NSMutableArray array];
    int totalCount = 0;
    int row = 15;
    
    FMResultSet *s = [_db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",address]];
    if ([s next]) {
        totalCount = [s intForColumnIndex:0];
    }
    
    if (totalCount != 0) {
        FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id BETWEEN '%ld' AND '%ld'",address,(long)(totalCount-(row * (offset + 1))),(long)(totalCount - (row * offset))]];
        while ([res next]) {
            ApexTransferModel *model = [self buildModelWithResult:res];
            [temp addObject:model];
        }
        
        [temp sortUsingComparator:^NSComparisonResult(ApexTransferModel *obj1, ApexTransferModel *obj2) {
            return obj1.time.integerValue > obj2.time.integerValue;
        }];
        temp = [[[temp reverseObjectEnumerator] allObjects] mutableCopy];
    }
    
    [_db close];
    return temp;
}

- (NSMutableArray *)getHistoryiesWithPrefixOfTxid:(NSString *)prefix address:(NSString *)address {
    [_db open];
    address = [self encodeAddress:address];
    NSMutableArray *array = [NSMutableArray array];
    
    if (![prefix hasPrefix:@"0x"]) {
        prefix = [NSString stringWithFormat:@"0x%@",prefix];
    }
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE txid LIKE '%@%%'",address,prefix]];
    
    while ([res next]) {
        ApexTransferModel *model = [self buildModelWithResult:res];
        [array addObject:model];
    }
    
    [_db close];
    
    return array;
}

- (id)getLastTransferHistoryOfAddress:(NSString *)address {
    [_db open];
    address = [self encodeAddress:address];
    ApexTransferModel *model = nil;
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT 1",address]];
    while ([res next]) {
        model = [self buildModelWithResult:res];
    }
    
    [_db close];
    return model;
}

- (NSArray*)getTransferHistoriesFromEndWithLimit:(NSString *)limite address:(NSString *)address{
    [_db open];
    address = [self encodeAddress:address];
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *set = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT %@",address,limite]];
    while ([set next]) {
        [arr addObject:[self buildModelWithResult:set]];
    }
    [_db close];
    return arr;
}

- (ApexTransferModel*)buildModelWithResult:(FMResultSet*)res{
    ApexTransferModel *model = [[ApexTransferModel alloc] init];
    model.txid = [res stringForColumn:@"txid"];
    model.assetId = [res stringForColumn:@"assetId"];
    model.decimal = [res stringForColumn:@"decimal"];
    model.from = [res stringForColumn:@"from"];
    model.to = [res stringForColumn:@"to"];
    model.gas_consumed = [res stringForColumn:@"gas_consumed"];
    model.imageURL = [res stringForColumn:@"imageURL"];
    model.symbol = [res stringForColumn:@"symbol"];
    model.time = [res stringForColumn:@"time"];
    model.type = [res stringForColumn:@"type"];
    model.value = [res stringForColumn:@"value"];
    model.vmstate = [res stringForColumn:@"vmstate"];
    model.status = [res intForColumn:@"state"] ;
    return model;
}

- (NSString*)encodeAddress:(NSString*)address{
    if ([address hasPrefix:@"0x"]) {
        return [NSString MD5String:address salt:@"ETH"];
    }else{
        return address;
    }
}

//request

- (void)requestTxHistoryForAddress:(NSString *)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure {
    
}

- (void)secreteUpdateUserTransactionHistoryAddress:(NSString *)address {
    
}

- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString *)txid ofWallet:(NSString *)walletAddress {
    
}


@end
