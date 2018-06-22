//
//  ApexTransferHistoryManager.m
//  Apex
//
//  Created by chinapex on 2018/6/22.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexTransferHistoryManager.h"
#import <FMDB.h>
#import "ApexTransferModel.h"

@interface ApexTransferHistoryManager()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ApexTransferHistoryManager
#pragma mark - ------singleton-----
// 创建静态对象 防止外部访问
static ApexTransferHistoryManager *_instance;
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
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"transHistory.sqlite"];
    NSLog(@"database path: %@",filePath);
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
}

#pragma mark - ------public-----
- (void)createTableForWallet:(NSString*)walletAddress{
    [_db open];
    // 初始化数据表
    NSString *addressSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'txid' VARCHAR(255),'assetId' VARCHAR(255),'decimal' VARCHAR(255),'from' VARCHAR(255),'to' VARCHAR(255),'gas_consumed' VARCHAR(255),'imageURL' VARCHAR(255),'symbol' VARCHAR(255),'time' VARCHAR(255),'type' VARCHAR(255),'value' VARCHAR(255),'vmstate' VARCHAR(255),'state' INTEGER);",walletAddress];
    BOOL success = [_db executeUpdate:addressSql];
    if (success) {
        NSLog(@"表创建成功");
    }else{
        NSLog(@"表创建失败");
    }
    [_db close];
}

- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString*)walletAddress{
    [_db open];
    walletAddress = @"ANhiknDaRH9maXYDhVDUAat65KqrgHuVbV";
    
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ",walletAddress]];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"id"] integerValue]) {
            maxID = @([[res stringForColumn:@"id"] integerValue] ) ;
        }
    }
    maxID = @([maxID integerValue] + 1);
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",walletAddress];
    [_db executeUpdate:sql,maxID,model.txid,model.assetId,model.decimal,model.from,model.to,model.gas_consumed,model.imageURL,model.symbol,model.time,model.type,model.value,model.vmstate,@(model.status)];
    [_db close];
}

- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString*)txid ofWallet:(NSString*)walletAddress{
    [_db open];
    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE '%@' SET state = ?  WHERE txid = ? ",walletAddress],@(status),txid];
    [_db close];
}

- (NSMutableArray*)getAllTransferHistoryForAddress:(NSString*)address{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",address]];
    
    while ([res next]) {
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
        [dataArray addObject:model];
    }
    
    [_db close];
    return dataArray;
}

@end
