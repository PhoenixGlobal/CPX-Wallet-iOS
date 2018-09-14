//
//  CYLApiBaseManager.h
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/4/2.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "ReformerProtocol.h"

typedef NS_ENUM(NSInteger, APICallMethod) {
    APICallMethod_POST,
    APICallMethod_GET
};

@class CYLResponse;
//网络回调代理
@protocol CYLApiBaseManagerDelegate <NSObject>
- (void)callApiDidSuccess:(CYLApiBaseManager*)apiManager;
- (void)callApiDidFailed:(NSError*)error;
@end

@protocol APIManager <NSObject>
@required
- (NSString*)getUrl;
- (NSDictionary*)getParams;
- (APICallMethod)getMethod;

@optional
- (CYLNetWorkCachePolicy)getCachePolicy;
- (NSTimeInterval)getCachePeriod;
@end

@interface CYLApiBaseManager : NSObject

@property (nonatomic, weak) id<APIManager> child;

@property (nonatomic, strong) CYLResponse *response; /**< 请求响应 */
#pragma mark - reformer

/**
 将api返回通过给定的reformer进行修饰 并返回处理后的数据
 */
- (id)fetchDataWithReformer:(id<ReformerProtocol>)reformer;

@property (nonatomic, weak) id<CYLApiBaseManagerDelegate> delegate;
- (void)callApi;
@end
