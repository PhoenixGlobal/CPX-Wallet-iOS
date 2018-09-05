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

- (NSArray*)getTransferHistoriesFromEndWithLimit:(NSString *)limite address:(NSString *)address{
    return [[ApexTransHistoryDataBaseHelper shareDataBase] getTransferHistoriesFromEndWithLimit:limite address:address manager:self];
}


#pragma mark - tool


#pragma mark - request
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
                [[ApexTransHistoryDataBaseHelper shareDataBase] updateTransferStatus:ApexTransferStatus_Progressing forTXID:model.txid ofWallet:address manager:self];
                [ETHTxStatusManager writeTxWithTXID:model.txid currentBlockNumber:responseObject.blockNumber];
                
                //开始确认 12个块
                [ETHTxStatusManager beginConfirmationCountDownWithConfirmationNumber:12 txid:model.txid doneBlock:^{
                    
                    [[ETHWalletManager shareManager] setStatus:YES forWallet:address];
                    [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferSuccess:model.txid address:address manager:self];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TranferHasConfirmed object:@""];
                    cancleTimer = YES;
                    [timer invalidate];
                }];
                
            }else if(responseObject.status && responseObject.status.integerValue == 0){
                //交易失败
                [[ApexTransHistoryDataBaseHelper shareDataBase] setTransferFail:model.txid address:address manager:self];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }];
    
    [[ApexThread shareInstance].threadRunLoop addTimer:aTimer forMode:NSRunLoopCommonModes];
    [aTimer fire];
}


- (void)requestTxHistoryForAddress:(NSString *)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure {
    
}

- (void)secreteUpdateUserTransactionHistoryAddress:(NSString *)address {
    
}

@end
