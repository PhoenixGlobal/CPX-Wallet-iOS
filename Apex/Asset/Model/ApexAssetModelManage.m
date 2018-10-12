//
//  ApexAssetModelManage.m
//  Apex
//
//  Created by chinapex on 2018/6/25.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexAssetModelManage.h"
#import "ApexAccountStateModel.h"

@implementation ApexAssetModelManage
+ (nullable NSMutableArray*)getLocalAssetModelsArr{
    NSMutableArray *arr = [TKFileManager loadDataWithFileName:KAssetModelListKey];
    if (!arr) {
        [self requestAssetlistSuccess:^(CYLResponse *response) {
        } fail:^(NSError *error) {
        }];
    }
    return arr;
}

+ (void)requestAssetlistSuccess:(successfulBlock)success fail:(failureBlock)failBlock{
    
    [CYLNetWorkManager GET:@"assets" CachePolicy:CYLNetWorkCachePolicy_DoNotCache activePeriod:0 parameter:@{} success:^(CYLResponse *response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *result = dict[@"data"];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in result) {
            ApexAssetModel *model = [ApexAssetModel yy_modelWithDictionary:dic];
            if ([model.type isEqualToString:@"NEP5"] || [model.hex_hash isEqualToString:assetId_Neo] || [model.hex_hash isEqualToString:assetId_NeoGas]) {
                [temp addObject:model];
            }
        }
        
        [TKFileManager saveData:temp withFileName:KAssetModelListKey];
        response.returnObj = temp;
        success(response);
        
    } fail:^(NSError *error) {
        failBlock(error);
    }];
}

+ (NSBundle *)resourceBundle{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/AssetResources.bundle"];
    NSBundle *resource = [NSBundle bundleWithPath:path];
    return resource;
}

@end
/**************************************************************************************************************************************/

@implementation ETHAssetModelManage
+ (nullable NSMutableArray*)getLocalAssetModelsArr{
    NSMutableArray *arr = [TKFileManager loadDataWithFileName:KETHAssetModelListKey];
    if (!arr) {
        arr = [NSMutableArray array];
        [self requestAssetlistSuccess:^(CYLResponse *response) {
        } fail:^(NSError *error) {
        }];
    }
    return arr;
}


//https://tracker.chinapex.com.cn/tool/eth-assets
+ (void)requestAssetlistSuccess:(successfulBlock)success fail:(failureBlock)failBlock{
    [CYLNetWorkManager GET:@"eth-assets" CachePolicy:CYLNetWorkCachePolicy_DoNotCache activePeriod:0 parameter:@{} success:^(CYLResponse *response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *result = dict[@"data"];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in result) {
            ApexAssetModel *model = [ApexAssetModel yy_modelWithDictionary:dic];
            if (![model.symbol isEqualToString:@"ETH"]) {
                [temp addObject:model];
            }
        }
//#warning fake data
//        ApexAssetModel *model1 = [ApexAssetModel new];
//        model1.hex_hash = assetID_Test_Erc20;
//        model1.precision = @"18";
//        model1.name = @"NMB";
//        model1.symbol  = @"NMB";
//        [temp addObject:model1];

        [TKFileManager saveData:temp withFileName:KETHAssetModelListKey];
        response.returnObj = temp;
        success(response);

    } fail:^(NSError *error) {
        failBlock(error);
    }];
}

+ (NSBundle *)resourceBundle{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/AssetResources.bundle"];
    NSBundle *resource = [NSBundle bundleWithPath:path];
    return resource;
}
@end

/**
 "type": "NEP5",
 "symbol": "ASA",
 "precision": "8",
 "name": "Asura World Coin",
 "image_url": "https://seeklogo.com/images/N/neo-logo-6D07F7C1E7-seeklogo.com.gif",
 "hex_hash": "0xa58b56b30425d3d1f8902034996fcac4168ef71d",
 "hash": "a58b56b30425d3d1f8902034996fcac4168ef71d"
 */
@implementation ApexAssetModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.symbol = [aDecoder decodeObjectForKey:@"symbol"];
        self.precision = [aDecoder decodeObjectForKey:@"precision"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.image_url = [aDecoder decodeObjectForKey:@"image_url"];
        self.hex_hash = [aDecoder decodeObjectForKey:@"hex_hash"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.symbol forKey:@"symbol"];
    [aCoder encodeObject:self.precision forKey:@"precision"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.image_url forKey:@"image_url"];
    [aCoder encodeObject:self.hex_hash forKey:@"hex_hash"];
}

- (BalanceObject *)convertToBalanceObject{
    BalanceObject *balanceObj = [[BalanceObject alloc] init];
    balanceObj.asset = self.hex_hash;
    balanceObj.value = @"0";
    return balanceObj;
}

@end
