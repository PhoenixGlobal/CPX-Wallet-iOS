//
//  ApexTransHistoryDataBaseHelper.m
//  Apex
//
//  Created by yulin chi on 2018/8/31.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexTransHistoryDataBaseHelper.h"
#import "ApexTransferModel.h"
@class ApexTransferHistoryManager;
@class ETHTransferHistoryManager;

@interface ApexTransHistoryDataBaseHelper()
@property (nonatomic, strong) FMDatabase *db; /**< 通用db */
@end

@implementation ApexTransHistoryDataBaseHelper
singleM(DataBase);

#pragma mark - database operation
- (FMDatabase*)dataBaseWithManager:(id<ApexTransHistoryProtocal>)manager{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"transHistory.sqlite"];
    NSLog(@"database path: %@",filePath);
    // 实例化FMDataBase对象
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    _db = db;
    return db;
}

- (void)createTableForWallet:(NSString*)walletAddress manager:(id<ApexTransHistoryProtocal>)manager successCreated:(dispatch_block_t)dbSuccess{
    [_db open];
    // 初始化数据表
    walletAddress = [self encodeAddress:walletAddress manager:manager];
    
    NSString *addressSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'txid' VARCHAR(255),'assetId' VARCHAR(255),'decimal' VARCHAR(255),'from' VARCHAR(255),'to' VARCHAR(255),'gas_consumed' VARCHAR(255),'imageURL' VARCHAR(255),'symbol' VARCHAR(255),'time' VARCHAR(255),'type' VARCHAR(255),'value' VARCHAR(255),'vmstate' VARCHAR(255),'state' INTEGER);",walletAddress];
    BOOL success = [_db executeUpdate:addressSql];
    if (success) {
        NSLog(@"表创建成功");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (dbSuccess) {
                dbSuccess();
            }
        });
    }
    [_db close];
}

- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString *)walletAddress manager:(id<ApexTransHistoryProtocal>)manager {
    [_db open];
    
    walletAddress = [self encodeAddress:walletAddress manager:manager];
    
    NSNumber *maxID = @(0);
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ",walletAddress]];
    BOOL isLocalDataProcessing = false;
    BOOL isDelete = false;
    //获取数据库中最大的ID
    while ([res next]) {
        //本地数据的交易号以及状态
        NSString *txidInDB = [res stringForColumn:@"txid"];
        NSInteger status = [res intForColumn:@"state"];
        maxID = @([[res stringForColumn:@"id"] integerValue]);
        
        //网络请求数据与本地有冲突时 以网络为准 删除本地此条数据 重新写入
        //本地数据的状态为已确认的状态时才替换
        if ([txidInDB isEqualToString:model.txid] && (status == ApexTransferStatus_Confirmed || status == ApexTransferStatus_Failed)) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %@",walletAddress,maxID.stringValue];
            if (![_db executeUpdate:sql]){
                NSLog(@"删除冗余数据失败");
            }else{
                NSLog(@"%@", [NSString stringWithFormat:@"删除冗余数据:%@",txidInDB]);
                isDelete = YES;
            }
        }
        
        if (status == ApexTransferStatus_Progressing) {
            isLocalDataProcessing = true;
        }
        
        if (isDelete) {
            maxID = @([maxID integerValue]);
            break;
        }else{
            maxID = @([maxID integerValue] + 1);
        }
    }
    
    if (!isLocalDataProcessing) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",walletAddress];
        [_db executeUpdate:sql,maxID,model.txid,model.assetId,model.decimal,model.from,model.to,model.gas_consumed,model.imageURL,model.symbol,model.time,model.type,model.value,model.vmstate,@(model.status)];
        [self updateRequestTime:@(model.time.integerValue) address:walletAddress];
    }
    
    [res close];
    [_db close];
}

- (void)updateRequestTime:(NSNumber*)timestamp address:(NSString*)address{
    [TKFileManager saveValue:timestamp forKey:LASTUPDATETXHISTORY_KEY(address)];
}

#pragma mark - tools
- (NSString*)encodeAddress:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager{
    if ([manager isKindOfClass:NSClassFromString(@"ETHTransferHistoryManager")]) {
        return [NSString MD5String:address salt:@"ETH"];
    }else if([manager isKindOfClass:NSClassFromString(@"ApexTransferHistoryManager")]){
        return [NSString MD5String:address salt:@"NEO"];
    }
    return @"";
}
@end
