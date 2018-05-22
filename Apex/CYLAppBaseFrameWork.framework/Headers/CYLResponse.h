//
//  CYLResponse.h
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/3/29.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface CYLResponse : NSObject<NSCoding>
@property (nonatomic, strong) id returnObj;
@property (nonatomic, assign) CYLNetWorkCachePolicy cachePolicy;
@property (nonatomic, strong) NSString *cacheKey;
@property (nonatomic, assign) NSTimeInterval cachePeriod; /**< 缓存的有效时间 */
@property (nonatomic, assign) NSTimeInterval firstCacheTime; /**< 首次缓存的时间戳 */
@property (nonatomic, strong) NSString *url;
@end
