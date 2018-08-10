//
//  ApexRPCClient.m
//  Apex
//
//  Created by chinapex on 2018/5/18.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexNeoClient.h"
#import <AFJSONRPCClient.h>
#import "ApexNetWorkCommonConfig.h"


@interface ApexNeoClient()
@property (nonatomic, strong) AFJSONRPCClient *client;
@end

@implementation ApexNeoClient
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

- (void)resetClient{
    self.client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ApexNetWorkCommonConfig getCliBaseUrl]]];
    AFSecurityPolicy *sp = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    sp.allowInvalidCertificates = YES;
    sp.validatesDomainName = NO;
    _client.securityPolicy = sp;
}

#pragma mark - setter getter
- (AFJSONRPCClient *)client{
    if (!_client) {
        NSString *baseUrl = [ApexNetWorkCommonConfig getCliBaseUrl];
        NSLog(@"cli baseurl: %@",baseUrl);
        _client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:baseUrl]];
        AFSecurityPolicy *sp = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        sp.allowInvalidCertificates = YES;
        sp.validatesDomainName = NO;
        _client.securityPolicy = sp;
    }
    return _client;
}
@end
