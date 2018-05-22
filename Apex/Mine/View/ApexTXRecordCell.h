//
//  ApexTXRecordCell.h
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexTXRecorderModel.h"
@interface ApexTXRecordCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *fromAddress;
@property (weak, nonatomic) IBOutlet UILabel *toAddress;
@property (weak, nonatomic) IBOutlet UILabel *Value;
@property (weak, nonatomic) IBOutlet UILabel *txidL;
@property (nonatomic, strong) ApexTXRecorderModel *model;
@end
