//
//  ApexAssetCell.h
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexAccountStateModel.h"
@interface ApexAssetCell : UITableViewCell
@property (nonatomic, strong) BalanceObject *model;
@property (nonatomic, assign) ApexWalletType type; /**<  */
@end
