//
//  ApexTransactionModel.h
//  Apex
//
//  Created by yulin chi on 2018/8/10.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

//eth 交易
@interface ApexETHTransactionModel : NSObject
@property (nonatomic, strong) NSString *tx_hash; /**<  hash*/
@property (nonatomic, strong) NSString *nonce; /**< trans count */
@property (nonatomic, strong) NSString *blockHash; /**<  */
@property (nonatomic, strong) NSString *blockNumber; /**< hex: block number where this transaction was in. null when its pending. */
@property (nonatomic, strong) NSString *transactionIndex; /**<  */
@property (nonatomic, strong) NSString *from; /**< from */
@property (nonatomic, strong) NSString *to; /**< to */
@property (nonatomic, strong) NSString *value; /**<  */
@property (nonatomic, strong) NSString *gas; /**<  */
@property (nonatomic, strong) NSString *gasPrice; /**<  */
@property (nonatomic, strong) NSString *input; /**< the data send along with the transaction. */
@end

//交易收据
@interface ApexETHReceiptModel: NSObject /* 交易收据 交易上链后才会有返回*/
@property (nonatomic, strong) NSString *transactionHash; /**<  */
@property (nonatomic, strong) NSString *transactionIndex; /**<  */
@property (nonatomic, strong) NSString *blockNumber; /**< decimal */
@property (nonatomic, strong) NSString *blockHash; /**<  */
@property (nonatomic, strong) NSString *cumulativeGasUsed; /**< The total amount of gas used when this transaction was executed in the block. */
@property (nonatomic, strong) NSString *gasUsed; /**< The amount of gas used by this specific transaction alone */
@property (nonatomic, strong) NSString *contractAddress; /**<  */
@property (nonatomic, strong) NSString *status; /**< hex: either 1 (success) or 0 (failure) */
@end
