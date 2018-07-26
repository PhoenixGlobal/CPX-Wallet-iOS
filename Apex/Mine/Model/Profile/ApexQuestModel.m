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

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.item_id = [aDecoder decodeObjectForKey:@"item_id"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.item_id forKey:@"item_id"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"item_id" : @"id"};
}

- (BOOL)isEqual:(ApexQuestItemBaseObject*)object{
    return [self.name isEqualToString:object.name];
}
@end
