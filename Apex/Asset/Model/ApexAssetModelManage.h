//
//  ApexAssetModelManage.h
//  Apex
//
//  Created by chinapex on 2018/6/25.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApexAssetModel;
@class BalanceObject;

@interface ApexAssetModelManage : NSObject
// 更新资产列表
+ (void)requestAssetlistSuccess:(successfulBlock)success fail:(failureBlock)failBlock;
// 获取本地资产列表
+ (NSMutableArray*)getLocalAssetModelsArr;

+ (NSBundle*)resourceBundle;
@end

@interface ETHAssetModelManage : NSObject
// 更新资产列表
+ (void)requestAssetlistSuccess:(successfulBlock)success fail:(failureBlock)failBlock;
// 获取本地资产列表
+ (NSMutableArray*)getLocalAssetModelsArr;

+ (NSBundle*)resourceBundle;
@end

@interface ApexAssetModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *precision;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *hex_hash; /**< 0xassetId */

- (BalanceObject*)convertToBalanceObject;
@end
