//
//  ApexSendMoneyGasCell.h
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApexSendMoneyGasCell : UITableViewCell

@property (nonatomic, strong) UILabel *currentGasSinglePriceL;
@property (nonatomic, strong) UISlider *gasSlider;

@property (nonatomic, strong) UILabel *slowL;
@property (nonatomic, strong) UILabel *currentGasPriceL;
@property (nonatomic, strong) UILabel *fastL;

//@property (nonatomic, strong) UILabel *TotalEthTitle;
@property (nonatomic, strong) UILabel *totalETHL;

@end

NS_ASSUME_NONNULL_END
