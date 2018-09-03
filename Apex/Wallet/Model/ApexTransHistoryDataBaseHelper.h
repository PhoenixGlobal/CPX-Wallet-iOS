//
//  ApexTransHistoryDataBaseHelper.h
//  Apex
//
//  Created by yulin chi on 2018/8/31.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApexTransHistoryProtocal.h"
#import <FMDB.h>


/**
 交易记录的数据库辅助类 用于管理通用api
 */
@interface ApexTransHistoryDataBaseHelper : NSObject
singleH(DataBase);
/**
 根据manager来初始化数据库
 */
- (FMDatabase*)dataBaseWithManager:(id<ApexTransHistoryProtocal>)manager;


/**
 根据manager 创建table
 */
- (void)createTableForWallet:(NSString*)walletAddress manager:(id<ApexTransHistoryProtocal>)manager successCreated:(dispatch_block_t)dbSuccess;


/**
 新增交易记录
 */
- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString *)walletAddress manager:(id<ApexTransHistoryProtocal>)manager;

- (void)beginTimerToConfirmTransactionOfAddress:(NSString *)address txModel:(ApexTransferModel *)model manager:(id<ApexTransHistoryProtocal>)manager ;
@end
