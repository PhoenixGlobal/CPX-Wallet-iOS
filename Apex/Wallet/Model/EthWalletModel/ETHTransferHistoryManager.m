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
#import "ETHTxStatusManager.h"
#import <AFNetworking.h>
#import "ETHTransferModel.h"

#define timerInterval 10.0
#define confirmHeight 3
#define confirmationCount 12

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

- (void)applicationIntializeSelfCheckWithAddress:(NSString *)address {
//    ApexTransferModel *last = [self getLastTransferHistoryOfAddress:address];
//    if (last == nil) return;
//    if (last.status == ApexTransferStatus_Blocking || last.status == ApexTransferStatus_Progressing) {
//        //开启循环更新状态
//        [self beginTimerToConfirmTransactionOfAddress:address txModel:last];
//    }else{
//        [[ApexWalletManager shareManager] setStatus:YES forWallet:address];
//    }
    
    NSArray *arr = [self getLastLimit:@(3) TransferHistoryOfAddress:address];
    for (ApexTransferModel *last in arr) {
        if (last.status == ApexTransferStatus_Blocking || last.status == ApexTransferStatus_Progressing) {
                //开启循环更新状态
                [self beginTimerToConfirmTransactionOfAddress:address txModel:last];
            }else{
                [[ApexWalletManager shareManager] setStatus:YES forWallet:address];
            }
    }
}

#pragma mark - ------增-----
- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString *)walletAddress {
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

#pragma mark - ------查-----

- (NSMutableArray *)getAllTransferHistoryForAddress:(NSString *)address {
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getAllTransferHistoryForAddress:address manager:self];
}

- (NSMutableArray *)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString *)address {
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getHistoriesOffset:offset walletAddress:address manager:self];
}

- (NSMutableArray *)getHistoryiesWithPrefixOfTxid:(NSString *)prefix address:(NSString *)address {
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getHistoryiesWithPrefixOfTxid:prefix address:address manager:self];
}

- (id)getLastTransferHistoryOfAddress:(NSString *)address {
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getLastTransferHistoryOfAddress:address manager:self];
}

- (NSArray*)getLastLimit:(NSNumber*)limit TransferHistoryOfAddress:(NSString *)address {
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getLastTransferLimite:limit HistoryOfAddress:address manager:self];
}

- (NSArray*)getTransferHistoriesFromEndWithLimit:(NSString *)limite address:(NSString *)address{
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getTransferHistoriesFromEndWithLimit:limite address:address manager:self];
}

#pragma mark - tool


#pragma mark - request
- (void)beginTimerToConfirmTransactionOfAddress:(NSString *)address txModel:(ApexTransferModel *)model {
    if (model.status == ApexTransferStatus_Blocking) {
        [[ETHWalletManager shareManager] setStatus:NO forWallet:address];
    }
    
    __block BOOL cancleTimer = false;
    __block BOOL isTXOnBlock = false; //交易是否已经上链 不论成功与否
    NSTimer *aTimer = [NSTimer timerWithTimeInterval:timerInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (cancleTimer) {
            return;
        }
        
        //与neo此处的处理不同, 交易上链后才有返回,否则无返回 即block不被调用
        [ETHWalletManager requestTransactionReceiptByHash:model.txid success:^(AFHTTPRequestOperation *operation, ApexETHReceiptModel *responseObject) {
            
            isTXOnBlock = YES;
            if (responseObject.status && responseObject.status.integerValue == 1 && responseObject.blockHash) {
                //交易上链成功
                [[ApexTransHistoryDataBaseHelper shareDataBase] updateTransferStatus:ApexTransferStatus_Progressing forTXID:model.txid ofWallet:address manager:self];
                [ETHTxStatusManager writeTxWithTXID:model.txid currentBlockNumber:responseObject.blockNumber];
                
                //开始确认 12个块
                [ETHTxStatusManager beginConfirmationCountDownWithConfirmationNumber:confirmationCount txid:model.txid doneBlock:^{
                    
                    [[ETHWalletManager shareManager] setStatus:YES forWallet:address];
                    [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferSuccess:model.txid address:address manager:self];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TranferHasConfirmed object:@""];
                    cancleTimer = YES;
                    NSLog(@"eth 成功");
                    [timer invalidate];
                }];
            }
            
            if(responseObject.status && responseObject.status.integerValue == 0){
                //交易失败
                [[ETHWalletManager shareManager] setStatus:YES forWallet:address];
                [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferFail:model.txid address:address manager:self];
                cancleTimer = YES;
                [timer invalidate];
            }
            
            //交易还未上链时的监控
            if (!responseObject.blockHash) {
                [ETHTxStatusManager txStatusMonitor:model.txid address:address nonce:model.nonce timeOutBlock:^{
                    //此笔交易还未上链但是请求链上的nonce值已经增加
                    //交易失败
                    [[ETHWalletManager shareManager] setStatus:YES forWallet:address];
                    [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferFail:model.txid address:address manager:self];
                    cancleTimer = YES;
                    [timer invalidate];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
//        if (!isTXOnBlock) {
            [ETHTxStatusManager txStatusMonitor:model.txid address:address nonce:model.nonce timeOutBlock:^{
                //交易失败 链上已经查不到此交易
                [[ETHWalletManager shareManager] setStatus:YES forWallet:address];
                [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferFail:model.txid address:address manager:self];
                cancleTimer = YES;
                [timer invalidate];
            }];
//        }
        
    }];
    
    [[ApexThread shareInstance].threadRunLoop addTimer:aTimer forMode:NSRunLoopCommonModes];
    [aTimer fire];
}


- (void)requestTxHistoryForAddress:(NSString *)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure {
    NSString *encodeAddress = [[ApexTransHistoryDataBaseHelper shareDataBase] tableNameMappingFromAddress:address manager:self];
    //获取上次更新时间
    __block NSNumber *bBlock = [TKFileManager ValueWithKey:LASTUPDATETXHISTORY_KEY(encodeAddress)];
    
    if (!bBlock) {
        bBlock = @0;
        [TKFileManager saveValue:bBlock forKey:LASTUPDATETXHISTORY_KEY(encodeAddress)];
    }
    
    //此方法内部 调用了-addTransferHistory: forWallet:
    [self getTransactionHistoryWithAddress:address BeginBlock:bBlock.integerValue Success:^(CYLResponse *response) {
        
        if (success) {
            success(response);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)getTransactionHistoryWithAddress:(NSString *)addr BeginBlock:(NSTimeInterval)beginBlock Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure{
    
    beginBlock += 1;
    
    [CYLNetWorkManager GET:@"eth-transaction" parameter:@{@"address":addr,@"startblock":@(beginBlock).stringValue,@"endblock":@"99999999"} success:^(CYLResponse *response) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *txArr = dict[@"data"];
        
        for (NSDictionary *dict in txArr) {
            ETHTransferModel *model = [ETHTransferModel yy_modelWithDictionary:dict];
            model.status = ApexTransferStatus_Confirmed;
            
            if ([model.vmstate isEqualToString:@"1"]){
                model.status = ApexTransferStatus_Failed;
            }
            
            [tempArr addObject:model];
        }
        
        [tempArr sortUsingComparator:^NSComparisonResult(ETHTransferModel *obj1, ETHTransferModel *obj2) {
            return obj1.time.integerValue > obj2.time.integerValue;
        }];
        
        for (ETHTransferModel *txModel in tempArr) {
            [self addTransferHistory:txModel forWallet:addr];
        }
        
        response.returnObj = tempArr;
        
        if (success) {
            success(response);
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)secreteUpdateUserTransactionHistoryAddress:(NSString *)address {
    [self requestTxHistoryForAddress:address Success:^(CYLResponse *res) {
    } failure:^(NSError *err) {
    }];
}

@end
