//
//  ApexAddAssetCell.h
//  Apex
//
//  Created by chinapex on 2018/7/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexAddAssetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *indicator;
@property (nonatomic, strong) ApexAssetModel *model;
@end
