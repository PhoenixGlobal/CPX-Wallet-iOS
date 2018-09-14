//
//  ApexPrepareBackUpController.h
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexPrepareBackUpController : UIViewController
@property (nonatomic, strong) ApexWalletModel *model;
@property (nonatomic, copy) dispatch_block_t BackupCompleteBlock;
@property (nonatomic, assign) BOOL isFromCreat; /**<  */
@end
