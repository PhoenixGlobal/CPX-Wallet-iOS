//
//  ETHTxStatusManager.m
//  Apex
//
//  Created by yulin chi on 2018/9/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ETHTxStatusManager.h"

@implementation ETHTxStatusManager
+ (void)initTrackerDict{
    //初始化本地的交易状态追踪字典
    NSMutableDictionary *txTrackerDic = [TKFileManager loadDataWithFileName:KLocalTXTrackerKey];
    if (!txTrackerDic) {
        txTrackerDic = [NSMutableDictionary dictionary];
    }
    [TKFileManager saveData:txTrackerDic withFileName:KLocalTXTrackerKey];
}

//初始这笔交易发生时 当前得块数
+ (void)writeTxWithTXID:(NSString *)txid currentBlockNumber:(NSString*)cur{
    NSMutableDictionary *txTrackerDic = [TKFileManager loadDataWithFileName:KLocalTXTrackerKey];
    if (![txTrackerDic.allKeys containsObject:txid]) {
        [txTrackerDic setValue:@(cur.integerValue) forKey:txid];
        [TKFileManager saveData:txTrackerDic withFileName:KLocalTXTrackerKey];
    }
}

+ (void)beginConfirmationCountDownWithConfirmationNumber:(NSInteger)confirmNum txid:(NSString*)txid doneBlock:(dispatch_block_t)doneBlock{
    [ETHWalletManager requestCurrentBlockNumberSuccess:^(AFHTTPRequestOperation *operation, NSString *responseObject) {
        
        NSMutableDictionary *txTrackerDic = [TKFileManager loadDataWithFileName:KLocalTXTrackerKey];
        NSNumber *txBlockNumber = txTrackerDic[txid];
        if (responseObject.integerValue - txBlockNumber.integerValue >= confirmNum) {
            [self tracingTxStatusSuccess:txid];
            if (doneBlock) {
                doneBlock();
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+ (void)tracingTxStatusSuccess:(NSString *)txid{
    NSMutableDictionary *txTrackerDic = [TKFileManager loadDataWithFileName:KLocalTXTrackerKey];
    [txTrackerDic removeObjectForKey:txid];
    [TKFileManager saveData:txTrackerDic withFileName:KLocalTXTrackerKey];
}
@end
