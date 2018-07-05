//
//  ApexAccountStateModel.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexAccountStateModel.h"

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
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.asset forKey:@"asset"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

- (BOOL)isEqualAsset:(BalanceObject*)object{
    return [object.asset isEqualToString:self.asset];
}

@end
