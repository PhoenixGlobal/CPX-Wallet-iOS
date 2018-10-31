//
//  ApexTransferHistoryManager.m
//  Apex
//
//  Created by chinapex on 2018/6/22.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexTransferHistoryManager.h"
#import "ApexTransferModel.h"
#import "ApexNeoTxStatusManager.h"
#import "ApexTransHistoryDataBaseHelper.h"

#define timerInterval 10.0
#define confirmHeight 6

@interface ApexTransferHistoryManager()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ApexTransferHistoryManager
#pragma mark - ------singleton-----
// 创建静态对象 防止外部访问
static ApexTransferHistoryManager *_instance;
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

#pragma mark - ------public-----
- (void)createTableForWallet:(NSString*)walletAddress{
    [[ApexTransHistoryDataBaseHelper shareDataBase] createTableForWallet:walletAddress manager:self successCreated:^{
        [self requestTxHistoryForAddress:walletAddress Success:^(CYLResponse *res) {
        } failure:^(NSError *err) {
        }];
    }];
}

- (void)secreteUpdateUserTransactionHistoryAddress:(NSString*)address{
    [self requestTxHistoryForAddress:address Success:^(CYLResponse *res) {
    } failure:^(NSError *err) {
    }];
}

#pragma mark - ------增-----
- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString*)walletAddress{
    [[ApexTransHistoryDataBaseHelper shareDataBase] addTransferHistory:model forWallet:walletAddress manager:self];
}

#pragma mark - ------删-----
- (void)deleteHistoryWithTxid:(NSString*)txid ofAddress:(NSString*)address{
    [[ApexTransHistoryDataBaseHelper shareDataBase] deleteHistoryWithTxid:txid ofAddress:address manager:self];
}

#pragma mark - ------改-----
- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString*)txid ofWallet:(NSString*)walletAddress{
    [[ApexTransHistoryDataBaseHelper shareDataBase] updateTransferStatus:status forTXID:txid ofWallet:walletAddress manager:self];
}

//应用开启时的自检测 是否有处理中的交易 并更新状态
- (void)applicationIntializeSelfCheckWithAddress:(NSString*)address{
    ApexTransferModel *last = [self getLastTransferHistoryOfAddress:address];
    if (last == nil) return;
    if (last.status == ApexTransferStatus_Blocking || last.status == ApexTransferStatus_Progressing) {
        //开启循环更新状态
        [self beginTimerToConfirmTransactionOfAddress:address txModel:last];
    }else{
        [[ApexWalletManager shareManager] setStatus:YES forWallet:address];
    }
}

#pragma mark - ------查-----
//查找txid前缀
- (NSMutableArray*)getHistoryiesWithPrefixOfTxid:(NSString*)prefix address:(NSString*)address{
    
   return [[ApexTransHistoryDataBaseHelper shareDataBase] getHistoryiesWithPrefixOfTxid:prefix address:address manager:self];
}

- (NSMutableArray*)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString*)address{
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getHistoriesOffset:offset walletAddress:address manager:self];
}

//获得所有的模型
- (NSMutableArray*)getAllTransferHistoryForAddress:(NSString*)address{
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getAllTransferHistoryForAddress:address manager:self];
}

//获取最新一条数据
- (ApexTransferModel*)getLastTransferHistoryOfAddress:(NSString*)address{
    return  [[ApexTransHistoryDataBaseHelper shareDataBase] getLastTransferHistoryOfAddress:address manager:self];
}

- (NSArray*)getTransferHistoriesFromEndWithLimit:(NSString *)limite address:(NSString *)address{
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getTransferHistoriesFromEndWithLimit:limite address:address manager:self];
}


//开启轮询 获取交易记录的最新状态
- (void)beginTimerToConfirmTransactionOfAddress:(NSString*)address txModel:(ApexTransferModel*)model{
    
    if (model.status == ApexTransferStatus_Blocking) {
        [[ApexWalletManager shareManager] setStatus:NO forWallet:address];
    }
    //开启交易上链前的状态追踪
    [ApexNeoTxStatusManager writeTxWithTXID:model.txid];
    
   __block BOOL cancleTimer = false;
    NSTimer *aTimer = [NSTimer timerWithTimeInterval:timerInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (cancleTimer) {
            return;
        }
        
        [[ApexTransferHistoryManager shareManager] requestBlockHeightWithTxid:model.txid success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dict = (NSDictionary*)responseObject;
            if ([dict.allKeys containsObject:@"confirmations"]) {
                //交易确认中 已经上链
                [self updateTransferStatus:ApexTransferStatus_Progressing forTXID:model.txid ofWallet:address];
                NSInteger confirmations = ((NSString*)dict[@"confirmations"]).integerValue;
                
                NSLog(@"%@", [NSString stringWithFormat:@"交易上链,confirmations:%ld",confirmations]);
                
                if (confirmations >= confirmHeight) {
                    //确认中
                    //交易成功
                    [[ApexWalletManager shareManager] setStatus:YES forWallet:address];
                    
                    [self verityIsTransactionTrulySuccess:model];
                    
//                    [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferSuccess:model.txid address:address manager:self];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TranferHasConfirmed object:@""];
                    cancleTimer = true;
                    [timer invalidate];
                }else{
                    //确认中
                    //设置钱包状态不可交易
                    [[ApexWalletManager shareManager] setStatus:NO forWallet:address];
                }
            }else{
                //交易还未上链 没有confirmation字段 但是可能之后会上链
                //超过6个块没响应 则判断交易失败
                [ApexNeoTxStatusManager tracingTXStatus:model.txid noResponseBlock:^(BOOL isResponding) {
                    if (!isResponding) {
                        //交易失败
                        [[ApexWalletManager shareManager] setStatus:YES forWallet:address];
                        [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferFail:model.txid address:address manager:self];
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TranferHasConfirmed object:@""];
                        cancleTimer = true;
                        [timer invalidate];
                    }
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }];
    
    [[ApexThread shareInstance].threadRunLoop addTimer:aTimer forMode:NSRunLoopCommonModes];
    [aTimer fire];
}

- (void)verityIsTransactionTrulySuccess:(ApexTransferModel*)model{
    
    [self VerifyTXHistoryFromServersWithAddress:model.from Success:^(CYLResponse *response) {
        
        NSArray *txs = response.returnObj;
        BOOL flag = false;
        for (ApexTransferModel *serversModel in txs) {
            if ([serversModel.txid isEqualToString:model.txid]) {
                flag = true;
                break;
            }
        }
        
        if (flag) {
            [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferSuccess:model.txid address:model.from manager:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TranferHasConfirmed object:@""];
        }else{
            [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferFail:model.txid address:model.from manager:self];
        }
        
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - ------request------
//根据txid获取此交易所在区块
- (void)requestBlockHeightWithTxid:(NSString*)txid success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [[ApexNeoClient shareRPCClient] invokeMethod:@"getrawtransaction" withParameters:@[txid,@1] success:success failure:failure];
}

- (void)VerifyTXHistoryFromServersWithAddress:(NSString*)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure{
    
    NSString *encodeAddress = [[ApexTransHistoryDataBaseHelper shareDataBase] tableNameMappingFromAddress:address manager:self];
    //获取上次更新时间
    __block NSNumber *bTime = [TKFileManager ValueWithKey:LASTUPDATETXHISTORY_KEY(encodeAddress)];
    
    if (!bTime) {
        bTime = @0;
        [TKFileManager saveValue:bTime forKey:LASTUPDATETXHISTORY_KEY(encodeAddress)];
    }
    
    [CYLNetWorkManager GET:@"transaction-history" parameter:@{@"address":address, @"beginTime":bTime} success:^(CYLResponse *response) {
        NSMutableArray *tempArr = [NSMutableArray array];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *txArr = dict[@"data"];
        for (NSDictionary *txDict in txArr) {
            ApexTransferModel *model = [ApexTransferModel yy_modelWithDictionary:txDict];
            if ([model.vmstate containsString:@"FAULT"]) {
                model.status = ApexTransferStatus_Failed;
            }else{
                model.status = ApexTransferStatus_Confirmed;
            }
            
            [tempArr addObject:model];
        }
        response.returnObj = tempArr;
        success(response);
        
    } fail:^(NSError *error) {
        failure(error);
    }];
}

//从服务器中获取交易历史记录
- (void)requestTxHistoryForAddress:(NSString*)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure{
    
    NSString *encodeAddress = [[ApexTransHistoryDataBaseHelper shareDataBase] tableNameMappingFromAddress:address manager:self];
    //获取上次更新时间
    __block NSNumber *bTime = [TKFileManager ValueWithKey:LASTUPDATETXHISTORY_KEY(encodeAddress)];
    
    if (!bTime) {
        bTime = @0;
        [TKFileManager saveValue:bTime forKey:LASTUPDATETXHISTORY_KEY(encodeAddress)];
    }

    //此方法内部 调用了-addTransferHistory: forWallet:
    [self getTransactionHistoryWithAddress:address BeginTime:bTime.integerValue Success:^(CYLResponse *response) {
        
        if (((NSArray*)response.returnObj).count == 500) {
            //请求下一组数据
            [self requestTxHistoryForAddress:address Success:success failure:failure];
        }else{
            
        }
        
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getTransactionHistoryWithAddress:(NSString *)addr BeginTime:(NSTimeInterval)beginTime Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure{
    
    [CYLNetWorkManager GET:@"transaction-history" parameter:@{@"address":addr, @"beginTime":@(beginTime)} success:^(CYLResponse *response) {
        NSMutableArray *tempArr = [NSMutableArray array];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *txArr = dict[@"data"];
        for (NSDictionary *txDict in txArr) {
            ApexTransferModel *model = [ApexTransferModel yy_modelWithDictionary:txDict];
            if ([model.vmstate containsString:@"FAULT"]) {
                model.status = ApexTransferStatus_Failed;
            }else{
                model.status = ApexTransferStatus_Confirmed;
            }
        
            if (model.from != model.to) {
                [[ApexTransferHistoryManager shareManager] addTransferHistory:model forWallet:addr];
            }
            
            [tempArr addObject:model];
        }
        
        response.returnObj = tempArr;
        success(response);
        
    } fail:^(NSError *error) {
        failure(error);
    }];
}

@end
