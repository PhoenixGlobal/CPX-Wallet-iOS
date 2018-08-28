//
//  ApexEncourageActivitysModel.m
//  Apex
//
//  Created by 冯志勇 on 2018/8/28.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexEncourageActivitysModel.h"

@implementation ApexEncourageActivitysModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.activityID = [aDecoder decodeObjectForKey:@"id"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.title_cn = [aDecoder decodeObjectForKey:@"title_cn"];
        self.title_en = [aDecoder decodeObjectForKey:@"title_en"];
        self.body_cn = [aDecoder decodeObjectForKey:@"body_cn"];
        self.body_en = [aDecoder decodeObjectForKey:@"body_en"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.imageurl = [aDecoder decodeObjectForKey:@"imageurl"];
        self.view_end_date = [aDecoder decodeObjectForKey:@"view_end_date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.activityID forKey:@"id"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.title_cn forKey:@"title_cn"];
    [aCoder encodeObject:self.title_en forKey:@"title_en"];
    [aCoder encodeObject:self.body_cn forKey:@"body_cn"];
    [aCoder encodeObject:self.body_en forKey:@"body_en"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.imageurl forKey:@"imageurl"];
    [aCoder encodeObject:self.view_end_date forKey:@"view_end_date"];
}

@end
