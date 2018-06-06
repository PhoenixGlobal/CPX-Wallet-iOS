//
//  ApexMorePanelController.h
//  Apex
//
//  Created by chinapex on 2018/6/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexMorePanelController : UIViewController
@property (nonatomic, strong) NSArray *walletsArr;/** 若是需要显示钱包切换cell 则传入此项 */
@property (nonatomic, strong) ApexWalletModel *curWallet;
@end
