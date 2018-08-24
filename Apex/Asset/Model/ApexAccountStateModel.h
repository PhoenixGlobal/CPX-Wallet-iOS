//
//  ApexAccountStateModel.h
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "version": 0,
 "script_hash": "0x3c237b3aa701c68364d4282a3c5a4e5197184f1b",
 "frozen": false,
 "votes": [],
 "balances": [
 {
 "asset": "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
 "value": "2"
 },
 {
 "asset": "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
 "value": "1.89"
 }
 ]
 */
@class BalanceObject;
@class ApexAssetModel;

@interface ApexAccountStateModel : NSObject
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *script_hash;
@property (nonatomic, strong) NSNumber *frozen;
@property (nonatomic, strong) NSArray<BalanceObject *> *balances;
@end

@interface BalanceObject : NSObject<NSCoding>
@property (nonatomic, strong) NSString *asset;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) NSString *gas; /**< eth*/

//查找相关的assetmodel
- (ApexAssetModel*)getRelativeNeoAssetModel;
- (ApexAssetModel*)getRelativeETHAssetModel;
- (BOOL)isHashEqual:(id)objct;
@end
