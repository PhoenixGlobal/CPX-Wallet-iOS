//
//  ApexSendMoneyController.h
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexSendMoneyController : UIViewController
@property (nonatomic, strong) NSString *walletName;
@property (nonatomic, strong) NSString *walletAddress;
@property (nonatomic, strong) BalanceObject *balanceModel;
@property (nonatomic, strong) id<ApexWalletManagerProtocal> walletManager; /**<  */
@property (nonatomic, strong) NSString *toAddressIfHave;
@property (nonatomic, strong) NSString *unit;
@end
