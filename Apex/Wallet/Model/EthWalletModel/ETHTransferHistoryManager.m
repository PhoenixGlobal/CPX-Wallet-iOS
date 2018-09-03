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
- (NSString*)encodeAddress:(NSString*)address{
    if ([address hasPrefix:@"0x"]) {
        return [NSString MD5String:address salt:@"ETH"];
    }else{
        return address;
    }
}

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


- (void)requestTxHistoryForAddress:(NSString *)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure {
    
}

- (void)secreteUpdateUserTransactionHistoryAddress:(NSString *)address {
    
}

@end
