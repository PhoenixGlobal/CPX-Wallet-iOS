//
//  CYLNetWorkManager.h
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/3/29.
//  Copyright © 2018年 chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLResponse.h"
#import "Constant.h"

@class AFHTTPSessionManager;
@class UIViewController;
static NSString *CYLNetWorkStatusHasChnagedNotification = @"CYLNetWorkStatusHasChnagedNotification";

typedef NS_ENUM(NSInteger,CYLNetWorkStatus) {
    CYLNetWorkStatus_UNKnow = -1,
    CYLNetWorkStatus_NotReachable,
    CYLNetWorkStatus_Celluler,
    CYLNetWorkStatus_Wifi
};
@interface CYLNetWorkManager : NSObject
+ (instancetype)shareInstance;
- (void)setBaseUrl:(NSURL*)baseurl;
- (CYLNetWorkStatus)currentNetWorkStatus;
- (AFHTTPSessionManager*)getManager;
#pragma mark - 网络请求

+ (NSURLSessionDataTask*)GET:(NSString*)url parameter:(id)param success:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock;

+ (NSURLSessionDataTask*)POST:(NSString*)url parameter:(id)param success:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock;

/**
 可以缓存的get请求

 @param url 请求路径
 @param policy 缓存策略
 @param period 缓存有效期
 @param param 参数
 */
+ (NSURLSessionDataTask*)GET:(NSString*)url CachePolicy:(CYLNetWorkCachePolicy)policy activePeriod:(NSTimeInterval)period parameter:(id)param success:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock;

/**
 可以缓存的Post请求
 
 @param url 请求路径
 @param policy 缓存策略
 @param period 缓存有效期
 @param param 参数
 */
+ (NSURLSessionDataTask*)POST:(NSString*)url CachePolicy:(CYLNetWorkCachePolicy)policy activePeriod:(NSTimeInterval)period parameter:(id)param success:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock;

#pragma mark - 网络权限
+ (void)monitorNetworkStatusOnViewController:(UIViewController*)vc;
@end
