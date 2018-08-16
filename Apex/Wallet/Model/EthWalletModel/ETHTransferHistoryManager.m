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

- (void)addTransferHistory:(id)model forWallet:(NSString *)walletAddress {
    
}

- (void)applicationIntializeSelfCheckWithAddress:(NSString *)address {
    
}

- (void)beginTimerToConfirmTransactionOfAddress:(NSString *)address txModel:(ApexTransferModel *)model {
    
}

- (void)createTableForWallet:(NSString *)walletAddress {
    
}

- (NSMutableArray *)getAllTransferHistoryForAddress:(NSString *)address {
    return [NSMutableArray array];
}

- (NSMutableArray *)getHistoriesOffset:(NSInteger)offset walletAddress:(NSString *)address {
    return [NSMutableArray array];
}

- (NSMutableArray *)getHistoryiesWithPrefixOfTxid:(NSString *)prefix address:(NSString *)address {
    return [NSMutableArray array];
}

- (id)getLastTransferHistoryOfAddress:(NSString *)address {
    return nil;
}

- (void)requestTxHistoryForAddress:(NSString *)address Success:(void (^)(CYLResponse *))success failure:(void (^)(NSError *))failure {
    
}

- (void)secreteUpdateUserTransactionHistoryAddress:(NSString *)address {
    
}

- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString *)txid ofWallet:(NSString *)walletAddress {
    
}

@end
