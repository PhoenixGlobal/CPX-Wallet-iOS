//
//  ApexTransferHistoryManager.h
//  Apex
//
//  Created by chinapex on 2018/6/22.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApexTransHistoryProtocal.h"

//交易状态改变的通知
#define Notification_TranferStatusHasChanged @"Notification_TranferStatusHasChanged"
#define Notification_TranferHasConfirmed @"Notification_TranferHasConfirmed"

@class ApexTransferModel;

@interface ApexTransferHistoryManager : NSObject<ApexTransHistoryProtocal>
singleH(Manager);

@end
