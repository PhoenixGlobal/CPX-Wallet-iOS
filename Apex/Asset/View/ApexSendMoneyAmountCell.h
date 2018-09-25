//
//  ApexSendMoneyAmountCell.h
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RouteNameEvent_AmountCellDidClickSendMoney @"RouteNameEvent_AmountCellDidClickSendMoney"
#define RouteNameEvent_AmountCellDidEditSendMoney @"RouteNameEvent_AmountCellDidEditSendMoney"

@interface ApexSendMoneyAmountCell : UITableViewCell

@property (nonatomic, strong) UILabel *availableL;
@property (nonatomic, strong) UITextField *sendNumTF;
@property (nonatomic, strong) UIButton *allSendBtn;
@property (nonatomic, strong) UILabel *unitL;

@end

NS_ASSUME_NONNULL_END
