//
//  ApexTransferManagerViewController.h
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApexTransferManagerViewController : UIViewController

@property (nonatomic, strong) NSString *walletName;
@property (nonatomic, strong) NSString *walletAddress;
@property (nonatomic, strong) BalanceObject *balanceModel;
@property (nonatomic, strong) id<ApexWalletManagerProtocal> walletManager; /**<  */
@property (nonatomic, strong) NSString *toAddressIfHave;
@property (nonatomic, strong) NSString *unit;

@end

NS_ASSUME_NONNULL_END
