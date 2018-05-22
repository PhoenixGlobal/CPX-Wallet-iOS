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
    [self.client invokeMethod:method success:success failure:failure];
}

- (void)invokeMethod:(NSString *)method
      withParameters:(id)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self.client invokeMethod:method withParameters:parameters requestId:@1 success:success failure:failure];
}

#pragma mark - setter getter
- (AFJSONRPCClient *)client{
    if (!_client) {
        _client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:baseUrl]];

    }
    return _client;
}
@end
