//
//  ApexSendMoneyViewModel.h
//  Apex
//
//  Created by chinapex on 2018/5/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexSendMoneyViewModel : NSObject
@property (nonatomic, strong) NSString *address; /* from address */
@property (nonatomic, strong) NSString *toAddress; /**<  */

//获取neo utxo
- (void)getUtxoSuccess:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock;

//交易eth
//- (void)ethTransactionWithWallet:(EthmobileWallet*)wallet;
@end
