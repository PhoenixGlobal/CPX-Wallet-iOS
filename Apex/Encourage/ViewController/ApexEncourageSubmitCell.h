//
//  ApexEncourageSubmitCell.h
//  Apex
//
//  Created by 冯志勇 on 2018/8/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexAlertTextField.h"

@interface ApexEncourageSubmitCell : UITableViewCell

@property (nonatomic, strong) ApexAlertTextField *inputTextField;
@property (nonatomic, strong) RACSignal *combineSignal;

@end
