//
//  ApexWalletModel.h
//  Apex
//
//  Created by chinapex on 2018/5/25.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexWalletModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSMutableArray *assetArr;
@property (nonatomic, strong) NSNumber *createTimeStamp;
@property (nonatomic, assign) BOOL isBackUp;

@property (nonatomic, assign) BOOL canTransfer; /**< 钱包是否可以交易 */
@end
