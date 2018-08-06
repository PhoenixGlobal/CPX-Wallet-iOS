//
//  ApexNoWalletView.h
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RouteEventName_NoWalletViewToCreateWallet @"RouteEventName_NoWalletViewToCreateWallet"

@interface ApexNoWalletView : UIView
- (void)setMessage:(NSString*)message;
- (void)setBtnHidden:(BOOL)isHidden;
@end
