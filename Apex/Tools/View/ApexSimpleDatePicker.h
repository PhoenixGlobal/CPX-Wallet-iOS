//
//  ApexSimpleDatePicker.h
//  Apex
//
//  Created by yulin chi on 2018/7/25.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectDate)(NSDate *date, NSString *dateStr);

@interface ApexSimpleDatePicker : UIView
+ (void)showDatePickerCompleteHandler:(didSelectDate)handler;
@end
