//
//  ApexTransferCell.h
//  Apex
//
//  Created by chinapex on 2018/5/29.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexTransferModel.h"

@interface ApexTransferCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *txidL;
@property (nonatomic, strong) UILabel *amountL;
@property (nonatomic, strong) UILabel *successFlag;
@property (nonatomic, strong) UILabel *timeStampL;
@property (nonatomic, strong) UIButton *pushBtn;
@property (nonatomic, strong) ApexTransferModel *model;
@end
