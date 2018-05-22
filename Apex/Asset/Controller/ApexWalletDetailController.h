//
//  ApexWalletDetailController.h
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApexAccountStateModel;
@interface ApexWalletDetailController : UIViewController
@property (nonatomic, strong) NSString *walletName;
@property (nonatomic, strong) NSString *walletAddress;
@property (nonatomic, strong) ApexAccountStateModel *accountModel;
@end
