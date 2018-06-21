//
//  ApexTransferStatusModel.h
//  Apex
//
//  Created by chinapex on 2018/6/21.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApexTransferModel : NSObject
@property (nonatomic, assign) ApexTransferStatus status; /**< 此笔交易的状态 */
@property (nonatomic, assign) NSInteger transferAtHeight; /**< 此笔交易所在的区块高度 */

@property (nonatomic, strong) NSString *fromAddr;
@property (nonatomic, strong) NSString *toAddr;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *timeStamp;
@property (nonatomic, strong) NSString *assetId;
@end

NS_ASSUME_NONNULL_END
