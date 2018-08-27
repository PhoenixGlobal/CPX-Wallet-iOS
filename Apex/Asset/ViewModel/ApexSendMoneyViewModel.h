//
//  ApexSendMoneyViewModel.h
//  Apex
//
//  Created by chinapex on 2018/5/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApexTransferHistoryManager.h"

@interface ApexSendMoneyViewModel : NSObject
@property (nonatomic, strong) NSString *address; /* from address */
@property (nonatomic, strong) NSString *toAddress; /**<  */
@property (nonatomic, strong) BalanceObject *balanceModel; /**<  */
@property (nonatomic, strong) NSString *amount; /**< 交易金额 */
@property (nonatomic, strong) NSString *gasSliderValue; /**< gas条的值 */
@property (nonatomic, strong) ApexTransferHistoryManager *historyManager; /**<  */
@property (nonatomic, strong) UIViewController *ownerVC; /**< VC */
@property (nonatomic, strong) NSString *currentEthNumber; /**< 当前以太币的余额 */

//获取neo utxo
- (void)getUtxoSuccess:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock;

//交易eth
- (void)ethTransactionWithWallet:(EthmobileWallet*)wallet;

//交易neo
- (void)neoTransactionWithWallet:(NeomobileWallet*)wallet;

//跟新账户eth余额
- (void)updateEthValue;
@end
