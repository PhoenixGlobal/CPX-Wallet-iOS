//
//  ApexAccountStateModel.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexAccountStateModel.h"
#import "ApexAssetModelManage.h"

@implementation ApexAccountStateModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"balances" : [BalanceObject class]};
}
@end

@implementation BalanceObject
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.asset = [aDecoder decodeObjectForKey:@"asset"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
        self.gas = [aDecoder decodeObjectForKey:@"gas"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.asset forKey:@"asset"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.gas forKey:@"gas"];
}

- (BOOL)isHashEqual:(id)objct{
    return self == objct;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:BalanceObject.class]) {
        return false;
    }
    
    typeof(self) balanceObj = object;
    return [balanceObj.asset isEqualToString:self.asset];
}

- (ApexAssetModel*)getRelativeNeoAssetModel{
    ApexAssetModel *model = nil;
    for (ApexAssetModel *asModel in [ApexAssetModelManage getLocalAssetModelsArr]) {
        if ([asModel.hex_hash isEqualToString:self.asset]) {
            model = asModel;
        }
    }
    
    return model;
}

- (ApexAssetModel *)getRelativeETHAssetModel{
    ApexAssetModel *model = nil;
    for (ApexAssetModel *asModel in [ETHAssetModelManage getLocalAssetModelsArr]) {
        if ([asModel.hex_hash isEqualToString:self.asset]) {
            model = asModel;
        }
    }
    
    return model;
}
@end
