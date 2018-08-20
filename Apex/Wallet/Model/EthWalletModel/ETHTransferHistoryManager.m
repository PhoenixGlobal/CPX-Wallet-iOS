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
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"transHistory.sqlite"];
    NSLog(@"database path: %@",filePath);
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
}

- (void)createTableForWallet:(NSString *)walletAddress {
    [_db open];
    // 初始化数据表
    NSString *addressSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'txid' VARCHAR(255),'assetId' VARCHAR(255),'decimal' VARCHAR(255),'from' VARCHAR(255),'to' VARCHAR(255),'gas_consumed' VARCHAR(255),'imageURL' VARCHAR(255),'symbol' VARCHAR(255),'time' VARCHAR(255),'type' VARCHAR(255),'value' VARCHAR(255),'vmstate' VARCHAR(255),'state' INTEGER);",walletAddress];
    BOOL success = [_db executeUpdate:addressSql];
    if (success) {
        NSLog(@"表创建成功");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self requestTxHistoryForAddress:walletAddress Success:^(CYLResponse *res) {
            } failure:^(NSError *err) {
            }];
        });
    }else{
        NSLog(@"表创建失败");
    }
    [_db close];
}

- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString *)walletAddress {
    [_db open];
    
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

- (void)beginTimerToConfirmTransactionOfAddress:(NSString *)address txModel:(ApexTransferModel *)model {
    if (model.status == ApexTransferStatus_Blocking) {
        [[ApexWalletManager shareManager] setStatus:NO forWallet:address];
    }
    
    __block BOOL cancleTimer = false;
    NSTimer *aTimer = [NSTimer timerWithTimeInterval:timerInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (cancleTimer) {
            return;
        }
        
        //与neo此处的处理不同, 交易上链后有返回,否则返回nil
        [ETHWalletManager requestTransactionReceiptByHash:model.txid success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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

- (NSMutableArray *)getAllTransferHistoryForAddress:(NSString *)address {
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC",address]];
    while ([res next]) {
        ApexTransferModel *model = [self buildModelWithResult:res];
        [dataArray addObject:model];
    }
    [_db close];
    return dataArray;
}

- (NSMutableArray *)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString *)address {
    [_db open];
    NSMutableArray *temp = [NSMutableArray array];
    int totalCount = 0;
    int row = 15;
    
    FMResultSet *s = [_db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",address]];
    if ([s next]) {
        totalCount = [s intForColumnIndex:0];
    }
    
    if (totalCount != 0) {
        FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id BETWEEN '%ld' AND '%ld'",address,(long)(totalCount-(row * (offset + 1))),(long)(totalCount - (row * offset))]];
        while ([res next]) {
            ApexTransferModel *model = [self buildModelWithResult:res];
            [temp addObject:model];
        }
        
        [temp sortUsingComparator:^NSComparisonResult(ApexTransferModel *obj1, ApexTransferModel *obj2) {
            return obj1.time.integerValue > obj2.time.integerValue;
        }];
        temp = [[[temp reverseObjectEnumerator] allObjects] mutableCopy];
    }
    
    [_db close];
    return temp;
}

- (NSMutableArray *)getHistoryiesWithPrefixOfTxid:(NSString *)prefix address:(NSString *)address {
    [_db open];
    NSMutableArray *array = [NSMutableArray array];
    
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

- (id)getLastTransferHistoryOfAddress:(NSString *)address {
    [_db open];
    ApexTransferModel *model = nil;
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT 1",address]];
    while ([res next]) {
        model = [self buildModelWithResult:res];
    }
    
    [_db close];
    return model;
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
    return model;
}

//request

- (void)requestTxHistoryForAddress:(NSString *)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure {
    
}

- (void)secreteUpdateUserTransactionHistoryAddress:(NSString *)address {
    
}

- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString *)txid ofWallet:(NSString *)walletAddress {
    
}

- (void)updateRequestTime:(NSNumber*)timestamp address:(NSString*)address{
    [TKFileManager saveValue:timestamp forKey:LASTUPDATETXHISTORY_KEY(address)];
}
@end
