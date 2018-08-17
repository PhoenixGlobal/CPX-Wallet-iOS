//
//  ApexPassWordConfirmAlertView.h
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(NeomobileWallet* wallet);

@interface ApexPassWordConfirmAlertView : NSObject
+ (void)showDeleteConfirmAlertAddress:(NSString*)address subTitle:(NSString*)subtitle Success:(successBlock)success fail:(dispatch_block_t)fail;

+ (void)showEntryPasswordAlertAddress:(NSString *)address walletManager:(id<ApexWalletManagerProtocal>)manager subTitle:(NSString*)subtitle Success:(successBlock)success fail:(dispatch_block_t)fail;
@end
