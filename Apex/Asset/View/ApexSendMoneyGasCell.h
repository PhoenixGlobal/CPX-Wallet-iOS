//
//  ApexSendMoneyGasCell.h
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RouteNameEvent_GasCellDidValueChange @"RouteNameEvent_GasCellDidValueChange"

@interface ApexSendMoneyGasCell : UITableViewCell

@property (nonatomic, strong) UISlider *gasSlider;

@property (nonatomic, strong) UILabel *currentGasPriceL;
@property (nonatomic, strong) UILabel *totalETHL;

@property (nonatomic, strong) NSString *gasGWei;

@end

NS_ASSUME_NONNULL_END
