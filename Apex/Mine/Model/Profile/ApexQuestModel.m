//
//  ApexQuestItemModel.m
//  Apex
//
//  Created by yulin chi on 2018/7/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexQuestModel.h"

@implementation ApexQuestModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":ApexQuestItemBaseObject.class};
}
@end



@implementation ApexQuestItemBaseObject

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"item_id" : @"id"};
}
@end
