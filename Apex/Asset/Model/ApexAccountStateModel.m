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

@end
