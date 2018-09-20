//
//  ApexTransHistoryDataBaseHelper.m
//  Apex
//
//  Created by yulin chi on 2018/8/31.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexTransHistoryDataBaseHelper.h"
#import "ApexTransferModel.h"
#import <FMDatabaseAdditions.h>

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
        
        //添加新字段
        [self insertNewColumn:_db tableName:walletAddress];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (dbSuccess) {
                dbSuccess();
            }
        });
    }
    [_db close];
}

- (void)insertNewColumn:(FMDatabase*)db tableName:(NSString*)tableName{
    if (![db columnExists:@"gasPrice" inTableWithName:tableName]) {
        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ VARCHAR(255)",tableName,@"gasPrice"];
        [db executeUpdate:alertStr];
    }
    
    if (![db columnExists:@"transferAtHeight" inTableWithName:tableName]) {
        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ VARCHAR(255)",tableName,@"transferAtHeight"];
        [db executeUpdate:alertStr];
    }
    
    if (![db columnExists:@"gasFee" columnName:tableName]) {
        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ VARCHAR(255)",tableName,@"gasFee"];
        [db executeUpdate:alertStr];
    }
}

#pragma mark - 增
- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString *)walletAddress manager:(id<ApexTransHistoryProtocal>)manager {
    [_db open];
    
    walletAddress = [self encodeAddress:walletAddress manager:manager];
    
    NSNumber *maxID = @(0);
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",walletAddress]];
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
    
    //非eth交易仅允许同一时间进行一笔交易, eth交易可以多笔交易
    if ([manager isKindOfClass:NSClassFromString(@"ETHTransferHistoryManager")]) {
        [self insertModel:model inTable:walletAddress maxID:maxID manager:manager db:_db];
    }else{
        if (!isLocalDataProcessing) {
            [self insertModel:model inTable:walletAddress maxID:maxID manager:manager db:_db];
        }
    }
    
    [res close];
    [_db close];
}

- (void)insertModel:(ApexTransferModel*)model inTable:(NSString*)tableName maxID:(NSNumber*)maxID manager:(id<ApexTransHistoryProtocal>)manager db:(FMDatabase*)db{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",tableName];
    [db executeUpdate:sql,maxID,model.txid,model.assetId,model.decimal,model.from,model.to,model.gas_consumed,model.imageURL,model.symbol,model.time,model.type,model.value,model.vmstate,@(model.status),model.gas_price,model.block_number,model.gas_fee];
    
    NSNumber *requestIdentifier = @(model.time.integerValue);
    if ([model.type isEqualToString:EthType] || [model.type isEqualToString:Erc20Type]) {
        requestIdentifier = @(model.block_number.integerValue);
    }
    
    [self updateRequestTime:requestIdentifier address:tableName manager:manager];
}

#pragma mark - 删
- (void)deleteHistoryWithTxid:(NSString*)txid ofAddress:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager{
    [_db open];
    address = [self encodeAddress:address manager:manager];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE txid = %@",address,txid];
    [_db executeUpdate:sql];
    [_db close];
}

#pragma mark - 改
- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString*)txid ofWallet:(NSString*)walletAddress manager:(id<ApexTransHistoryProtocal>)manager{
    [_db open];
    walletAddress = [self encodeAddress:walletAddress manager:manager];
    //广播交易状态改变
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET state = ?  WHERE txid = ? ",walletAddress],@(status),txid];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TranferStatusHasChanged object:@""];
    [_db close];
}

- (void)setTransferSuccess:(NSString*)txid address:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager{
    [self.db open];
    [self.db executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET state = ?  WHERE txid = ? ",[self encodeAddress:address manager:manager]],@(ApexTransferStatus_Confirmed),txid];
    [self.db close];
}

- (void)setTransferDuringConfirmation:(NSString*)txid address:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager{
    [self.db open];
    [self.db executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET state = ?  WHERE txid = ? ",[self encodeAddress:address manager:manager]],@(ApexTransferStatus_Progressing),txid];
    [self.db close];
}

- (void)setTransferFail:(NSString*)txid address:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager{
    [self.db open];
    [self.db executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET state = ?  WHERE txid = ? ",[self encodeAddress:address manager:manager]],@(ApexTransferStatus_Failed),txid];
    [self.db close];
}

#pragma mark - 查
- (NSMutableArray *)getAllTransferHistoryForAddress:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager{
    [_db open];
    address = [self encodeAddress:address manager:manager];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC",address]];
    while ([res next]) {
        ApexTransferModel *model = [self buildModelWithResult:res];
        [dataArray addObject:model];
    }
    [_db close];
    return dataArray;
}

- (NSMutableArray *)getHistoryiesWithPrefixOfTxid:(NSString *)prefix address:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager{
    [_db open];
    NSMutableArray *array = [NSMutableArray array];
    address = [self encodeAddress:address manager:manager];
    if (![prefix hasPrefix:@"0x"]) {
        prefix = [NSString stringWithFormat:@"0x%@",prefix];
    }
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE txid LIKE '%@%%'",address,prefix]];
    
    while ([res next]) {
        ApexTransferModel *model = [self buildModelWithResult:res];
        [array addObject:model];
    }
    
    [_db close];
    
    return array;
}

- (NSMutableArray *)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager{
    [_db open];
    address = [self encodeAddress:address manager:manager];
    NSMutableArray *temp = [NSMutableArray array];
    int totalCount = 0;
    int row = 15;
    
    FMResultSet *s = [_db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",address]];
    if ([s next]) {
        totalCount = [s intForColumnIndex:0];
    }
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id BETWEEN '%ld' AND '%ld'",address,(long)(totalCount-(row * (offset + 1))),(long)(totalCount - (row * offset))]];
    while ([res next]) {
        ApexTransferModel *model = [self buildModelWithResult:res];
        [temp addObject:model];
    }
    
    [temp sortUsingComparator:^NSComparisonResult(ApexTransferModel *obj1, ApexTransferModel *obj2) {
        return obj1.time.integerValue > obj2.time.integerValue;
    }];
    temp = [[[temp reverseObjectEnumerator] allObjects] mutableCopy];
    
    [_db close];
    return temp;
}

- (id)getLastTransferHistoryOfAddress:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager{
    [_db open];
    address = [self encodeAddress:address manager:manager];
    ApexTransferModel *model = nil;
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT 1",address]];
    while ([res next]) {
        model = [self buildModelWithResult:res];
    }
    
    [_db close];
    return model;
}


- (NSArray *)getTransferHistoriesFromEndWithLimit:(NSString *)limite address:(NSString *)address manager:(id<ApexTransHistoryProtocal>)manager{
    [_db open];
    address = [self encodeAddress:address manager:manager];
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *set = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT %@",address,limite]];
    while ([set next]) {
        [arr addObject:[self buildModelWithResult:set]];
    }
    [_db close];
    return arr;
}

#pragma mark - tools
- (void)updateRequestTime:(NSNumber*)timestamp address:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager{
    NSNumber *lastTime = [TKFileManager ValueWithKey:LASTUPDATETXHISTORY_KEY(address)];
    if (timestamp.integerValue > lastTime.integerValue) {
        [TKFileManager saveValue:timestamp forKey:LASTUPDATETXHISTORY_KEY(address)];
    }
}

- (NSString*)tableNameMappingFromAddress:(NSString*)addr manager:(id<ApexTransHistoryProtocal>)manager{
    return [self encodeAddress:addr manager:manager];
}

- (NSString*)encodeAddress:(NSString*)address manager:(id<ApexTransHistoryProtocal>)manager{
    
    if ([address hasPrefix:@"ETH"] || [address hasPrefix:@"NEO"]) {
        NSLog(@"地址已被加密过 无需再次加密");
        return  address;
    }
    
    if ([manager isKindOfClass:NSClassFromString(@"ETHTransferHistoryManager")]) {
        return [NSString stringWithFormat:@"ETH_%@",[NSString MD5String:address salt:@"ETH"]];
    }else if([manager isKindOfClass:NSClassFromString(@"ApexTransferHistoryManager")]){
        return [NSString stringWithFormat:@"NEO_%@",[NSString MD5String:address salt:@"NEO"]];
    }
    return @"";
}

- (ApexTransferModel*)buildModelWithResult:(FMResultSet*)res{
    ApexTransferModel *model = [[ApexTransferModel alloc] init];
    model.txid = [res stringForColumn:@"txid"];
    model.assetId = [res stringForColumn:@"assetId"];
    model.decimal = [res stringForColumn:@"decimal"];
    model.from = [res stringForColumn:@"from"];
    model.to = [res stringForColumn:@"to"];
    model.gas_consumed = [res stringForColumn:@"gas_consumed"];
    model.imageURL = [res stringForColumn:@"imageURL"];
    model.symbol = [res stringForColumn:@"symbol"];
    model.time = [res stringForColumn:@"time"];
    model.type = [res stringForColumn:@"type"];
    model.value = [res stringForColumn:@"value"];
    model.vmstate = [res stringForColumn:@"vmstate"];
    model.status = [res intForColumn:@"state"] ;
    model.gas_price = [res stringForColumn:@"gasPrice"];
    model.gas_fee = [res stringForColumn:@"gasFee"];
    model.block_number = [res stringForColumn:@"transferAtHeight"];
    return model;
}
@end
