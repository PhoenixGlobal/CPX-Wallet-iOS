//
//  ApexTransferCell.h
//  Apex
//
//  Created by chinapex on 2018/5/29.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexTXRecorderModel.h"

@interface ApexTransferCell : UITableViewCell
@property (nonatomic, strong) UILabel *toAddressL;
@property (nonatomic, strong) UILabel *amountL;
@property (nonatomic, strong) UILabel *timeStampL;
@property (nonatomic, strong) ApexTXRecorderModel *model;
@end
