//
//  ApexRewardListTableViewCell.h
//  Apex
//
//  Created by 冯志勇 on 2018/8/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexRewardListTableViewCell : UITableViewCell

- (void)updaetRewardWithDictionary:(NSDictionary *)rewardDictionary;

+ (CGFloat)getContentHeightWithDictionary:(NSDictionary *)rewardDictionary;

@end
