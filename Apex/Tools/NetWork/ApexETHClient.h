//
//  ApexETHClient.h
//  Apex
//
//  Created by yulin chi on 2018/8/10.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;
@interface ApexETHClient : NSObject
singleH(RPCClient);
- (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)invokeMethod:(NSString *)method
      withParameters:(id)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
