//
//  ApexChangeBindWalletController.h
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexChangeBindWalletController : UIViewController
@property (nonatomic, strong) RACSubject *didSelectCellSub; /**<  */

@property (nonatomic, strong) ApexWalletModel *transHistoryWalletModel; /**< 传入此model代表要看的是历史记录的切换钱包,否则个人画像的切换 */
@end
