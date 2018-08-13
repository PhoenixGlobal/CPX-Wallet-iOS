//
//  ETHWalletModel.h
//  Apex
//
//  Created by yulin chi on 2018/8/13.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETHWalletModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSMutableArray *assetArr;
@property (nonatomic, strong) NSNumber *createTimeStamp;
@property (nonatomic, assign) BOOL isBackUp;

@property (nonatomic, assign) BOOL canTransfer;
@end
