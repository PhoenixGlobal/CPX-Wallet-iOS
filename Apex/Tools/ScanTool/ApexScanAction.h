//
//  ApexScanAction.h
//  Apex
//
//  Created by chinapex on 2018/6/6.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexScanAction : NSObject
@property (nonatomic, strong) ApexWalletModel *curWallet;
@property (nonatomic, strong) BalanceObject *balanceMode;
@property (nonatomic, assign) ApexWalletType type; /**<  */
singleH(ScanHelper);
+ (void)scanActionOnViewController:(UIViewController*)vc;
@end
