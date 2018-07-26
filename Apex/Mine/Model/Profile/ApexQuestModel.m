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


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *typeNum = dic[@"type"];
    
    if (![typeNum isKindOfClass:NSNumber.class]) return NO;
    
    _realTypeNum = typeNum;
    NSInteger type = typeNum.integerValue;
    
    if (type == 0) {
        _type = ApexQuestType_Texting;
    }else if (type < 20){
        _type = ApexQuestType_singleRow;
    }else if (type < 30){
        _type = ApexQuestType_DoubleRows;
    }else if (type < 40){
        _type = ApexQuestType_TripleRows;
    }else if (type < 50){
        _type = ApexQuestType_Tags;
    }
    
    if (type == -1) {
        _type = ApexQuestType_Local;
    }
    
    return YES;
}

@end



@implementation ApexQuestItemBaseObject

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"item_id" : @"id"};
}
@end
