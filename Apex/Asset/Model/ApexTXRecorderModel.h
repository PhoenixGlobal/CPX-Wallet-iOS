//
//  ApexTXRecorderModel.h
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexTXRecorderModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *txid; /**< 交易id */
@property (nonatomic, strong) NSString *fromAddress;/**< 转账地址 */
@property (nonatomic, strong) NSString *toAddress; /**< 收款地址 */
@property (nonatomic, strong) NSString *value; /**< 款项 */
@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSString *timeStamp; /**< 转账时间 */
@end
