//
//  ApexAssetModelManage.m
//  Apex
//
//  Created by chinapex on 2018/6/25.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexAssetModelManage.h"

@implementation ApexAssetModelManage

+ (void)requestAssetlistSuccess:(successfulBlock)success fail:(failureBlock)failBlock{
    
    [CYLNetWorkManager GET:@"assets" CachePolicy:CYLNetWorkCachePolicy_OnlyMemory activePeriod:300 parameter:@{} success:^(CYLResponse *response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *result = dict[@"result"];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in result) {
            ApexAssetModel *model = [ApexAssetModel yy_modelWithDictionary:dic];
            [temp addObject:model];
        }
        response.returnObj = temp;
        success(response);
        
    } fail:^(NSError *error) {
        failBlock(error);
    }];
}

@end


@implementation ApexAssetModel

@end
