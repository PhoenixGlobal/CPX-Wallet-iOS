//
//  ApexNeoTxStatusManager.m
//  Apex
//
//  Created by yulin chi on 2018/8/28.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexNeoTxStatusManager.h"

@implementation ApexNeoTxStatusManager
+ (void)initTrackerDict{
    //初始化本地的交易状态追踪字典
    NSMutableDictionary *txTrackerDic = [TKFileManager loadDataWithFileName:KLocalTXTrackerKey];
    if (!txTrackerDic) {
        txTrackerDic = [NSMutableDictionary dictionary];
    }
    [TKFileManager saveData:txTrackerDic withFileName:KLocalTXTrackerKey];
}

//初始这笔交易发生时 当前得块数
+ (void)writeTxWithTXID:(NSString *)txid{
    NSMutableDictionary *txTrackerDic = [TKFileManager loadDataWithFileName:KLocalTXTrackerKey];
    
    if (![txTrackerDic.allKeys containsObject:txid]) {
        [ApexWalletManager getCurrentBlockNumberSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [txTrackerDic setValue:responseObject forKey:txid];
            [TKFileManager saveData:txTrackerDic withFileName:KLocalTXTrackerKey];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}

//跟踪这笔交易是否上链
+ (void)tracingTXStatus:(NSString *)txid noResponseBlock:(void (^)(BOOL isResponding))block{
    
    NSMutableDictionary *txTrackerDic = [TKFileManager loadDataWithFileName:KLocalTXTrackerKey];
    if ([txTrackerDic.allKeys containsObject:txid]) {
        NSInteger blockNumber = ((NSNumber*)txTrackerDic[txid]).integerValue;
        [ApexWalletManager getCurrentBlockNumberSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSInteger curNumber = ((NSNumber*)responseObject).integerValue;
            if (curNumber - blockNumber > 10 && block) {
                block(false);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        [self writeTxWithTXID:txid];
    }
}

+ (void)tracingTxStatusSuccess:(NSString *)txid{
    NSMutableDictionary *txTrackerDic = [TKFileManager loadDataWithFileName:KLocalTXTrackerKey];
    [txTrackerDic removeObjectForKey:txid];
    [TKFileManager saveData:txTrackerDic withFileName:KLocalTXTrackerKey];
}
@end
