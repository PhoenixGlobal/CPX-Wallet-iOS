//
//  ApexWalletDetailController.h
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BalanceObject;
@interface ApexWalletDetailController : UIViewController
@property (nonatomic, strong) ApexWalletModel *wallModel;
@property (nonatomic, strong) BalanceObject *balanceModel;
@end
