//
//  ETHTxStatusManager.m
//  Apex
//
//  Created by yulin chi on 2018/9/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ETHTxStatusManager.h"

#define limitMins 5 * 60

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

+ (void)txStatusMonitor:(NSString *)txid address:(NSString*)address nonce:(NSString *)theNonce timeOutBlock:(dispatch_block_t)timeOutBlock{
    
    NSMutableDictionary *nonceTrackerDic = [TKFileManager loadDataWithFileName:KEthNonceTrackerKey];
    if (!nonceTrackerDic) {
        nonceTrackerDic = [NSMutableDictionary dictionary];
    }
    
    if ([nonceTrackerDic.allKeys containsObject:txid]) {
        //已存在本地
        NSString *str = nonceTrackerDic[txid];
        NSString *nonce = [str componentsSeparatedByString:@"/"].firstObject;
        NSString *time = [str componentsSeparatedByString:@"/"].lastObject;
        NSString *currentTime = @([NSDate date].timeIntervalSince1970).stringValue;
        if (currentTime.integerValue - time.integerValue > limitMins) {
            //查询nonce
            [ETHWalletManager requestTransactionCount:address success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *onBlockNonce = [SystemConvert hexToDecimal:responseObject];
                NSString *localNonce = [SystemConvert hexToDecimal:nonce];
                if (localNonce.integerValue < onBlockNonce.integerValue) {
                    if (timeOutBlock) {
                        timeOutBlock();
                    }
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        
    }else{
        //初次写入本地
        NSString *timeStamp = @([NSDate date].timeIntervalSince1970).stringValue;
        [nonceTrackerDic setValue:[NSString stringWithFormat:@"%@/%@",theNonce,timeStamp] forKey:txid];
    }
    
    [TKFileManager saveData:nonceTrackerDic withFileName:KEthNonceTrackerKey];
}


@end
