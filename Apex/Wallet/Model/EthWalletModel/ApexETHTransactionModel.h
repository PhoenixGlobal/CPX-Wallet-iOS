//
//  ApexTransactionModel.h
//  Apex
//
//  Created by yulin chi on 2018/8/10.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexETHTransactionModel : NSObject
@property (nonatomic, strong) NSString *tx_hash; /**<  hash*/
@property (nonatomic, strong) NSString *nonce; /**< trans out time */
@property (nonatomic, strong) NSString *blockHash; /**<  */
@property (nonatomic, strong) NSString *blockNumber; /**< hex */
@property (nonatomic, strong) NSString *transactionIndex; /**<  */
@property (nonatomic, strong) NSString *from; /**< from */
@property (nonatomic, strong) NSString *to; /**< to */
@property (nonatomic, strong) NSString *value; /**<  */
@property (nonatomic, strong) NSString *gas; /**<  */
@property (nonatomic, strong) NSString *gasPrice; /**<  */
@property (nonatomic, strong) NSString *input; /**< the data send along with the transaction. */
@end
