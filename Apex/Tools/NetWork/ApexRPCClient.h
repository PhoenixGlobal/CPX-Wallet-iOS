//
//  ApexRPCClient.h
//  Apex
//
//  Created by chinapex on 2018/5/18.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>



@class AFHTTPRequestOperation;
@interface ApexRPCClient : NSObject
singleH(RPCClient);

- (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)invokeMethod:(NSString *)method
      withParameters:(id)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
