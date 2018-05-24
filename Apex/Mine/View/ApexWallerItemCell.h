//
//  ApexWallerItemCell.h
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexAccountStateModel.h"

@interface ApexWallerItemCell : UITableViewCell
@property (weak, nonatomic) NSString *walletNameStr;
@property (weak, nonatomic) NSString *addressStr;
@property (nonatomic, strong) RACSubject *didFinishRequestBalanceSub; /**< 请求完毕时 传出sccountmodel */
- (ApexAccountStateModel*)getAccountInfo;
@end
