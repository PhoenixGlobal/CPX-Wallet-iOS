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


/**
 获取所有的交易记录
 */
- (NSMutableArray *)getAllTransferHistoryForAddress:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager;


/**
 根据txid前缀查找交易记录
 */
- (NSMutableArray*)getHistoryiesWithPrefixOfTxid:(NSString*)prefix address:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager;


/**
 获取交易记录
 */
- (NSMutableArray *)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager;


/**
 获取最后一条交易记录
 */
- (id)getLastTransferHistoryOfAddress:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager;


/**
倒序获取给定的交易记录
 */
- (NSArray*)getTransferHistoriesFromEndWithLimit:(NSString *)limite address:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager;

/**
 删除
 */
- (void)deleteHistoryWithTxid:(NSString*)txid ofAddress:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager;

/**
 更新交易状态
 */
- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString*)txid ofWallet:(NSString*)walletAddress manager:(id<ApexTransHistoryProtocal>)manager;

/**
 设置交易成功,失败
 */
- (void)setTransferSuccess:(NSString*)txid address:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager;

- (void)setTransferFail:(NSString*)txid address:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager;

/**
获取地址对应的表名
 */
- (NSString*)tableNameMappingFromAddress:(NSString*)addr manager:(id<ApexTransHistoryProtocal>)manager;
@end
