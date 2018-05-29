//
//  ApexTXRecorderModel.h
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexTXRecorderModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *fromAddress;
@property (nonatomic, strong) NSString *toAddress;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSString *timeStamp;
@end
