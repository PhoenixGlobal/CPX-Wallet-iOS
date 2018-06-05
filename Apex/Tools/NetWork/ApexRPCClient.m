//
//  ApexRPCClient.m
//  Apex
//
//  Created by chinapex on 2018/5/18.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexRPCClient.h"
#import <AFJSONRPCClient.h>



@interface ApexRPCClient()
@property (nonatomic, strong) AFJSONRPCClient *client;
@end

@implementation ApexRPCClient
singleM(RPCClient);

#pragma mark - private
- (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self.client invokeMethod:method success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self replaceClient];
        failure(operation, error);
    }];
}

- (void)invokeMethod:(NSString *)method
      withParameters:(id)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self.client invokeMethod:method withParameters:parameters requestId:@1 success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self replaceClient];
        failure(operation, error);
    }];
}


- (void)replaceClient{
    NSString *url = [[ApexBlockChainManager shareSharedManager].seedsArr firstObject];
    [[ApexBlockChainManager shareSharedManager].seedsArr removeObject:url];
    if (!url) {
        self.client = nil;
    }else{
        self.client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:url]];
    }
}

#pragma mark - setter getter
- (AFJSONRPCClient *)client{
    if (!_client) {
        _client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BlockChainBaseUrl_Test]];

    }
    return _client;
}

@end
