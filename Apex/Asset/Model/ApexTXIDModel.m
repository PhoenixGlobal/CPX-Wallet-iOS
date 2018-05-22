//
//  ApexTXIDModel.m
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexTXIDModel.h"

@implementation ApexTXIDModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"vin" : [VinObject class],
             @"vout" : [VoutObject class]
             };
}
@end


@implementation VinObject

@end

@implementation VoutObject

@end
