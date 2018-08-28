//
//  ApexEncourageActivitysModel.h
//  Apex
//
//  Created by 冯志勇 on 2018/8/28.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexEncourageActivitysModel : NSObject

@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *title_cn;
@property (nonatomic, strong) NSString *title_en;
@property (nonatomic, strong) NSString *body_cn;
@property (nonatomic, strong) NSString *body_en;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *view_end_date;

@end
