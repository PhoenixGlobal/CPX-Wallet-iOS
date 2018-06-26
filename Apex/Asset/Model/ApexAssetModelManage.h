//
//  ApexAssetModelManage.h
//  Apex
//
//  Created by chinapex on 2018/6/25.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApexAssetModel;

@interface ApexAssetModelManage : NSObject
// 获取资产列表
+ (void)requestAssetlistSuccess:(successfulBlock)success fail:(failureBlock)failBlock;
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
@interface ApexAssetModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *precision;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *hex_hash; /**< 0xassetId */
//@property (nonatomic, strong) NSString *hash;
@end
