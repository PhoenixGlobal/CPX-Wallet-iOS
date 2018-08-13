//
//  ApexBlockChainManager.m
//  Apex
//
//  Created by chinapex on 2018/5/28.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexBlockChainManager.h"
#import <AFNetworking.h>
#define neoScanNodesUrl @"api/main_net/v1/get_all_nodes"
#define maxFailTime 3

@interface NeoNodeObject : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger height;
@end

@implementation NeoNodeObject


@end
/////////////////////////////////////////////////////////////////////////////////////////////////////////

#define scanPeriod 10 * 60

@interface ApexBlockChainManager()
@property (nonatomic, strong) NSMutableArray *nodesArr;
@property (nonatomic, strong) AFHTTPSessionManager *neoScanManager;
@property (nonatomic, assign) NSInteger failTime;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ApexBlockChainManager
singleM(SharedManager);

- (void)prepare{
//    self.timer = [NSTimer timerWithTimeInterval:scanPeriod repeats:YES block:^(NSTimer * _Nonnull timer) {
//       [self lookingForSeed];
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    [self.timer fire];
//    
//    self.failTime = 0;
}

- (void)lookingForSeed{
    
    [self.neoScanManager GET:neoScanNodesUrl parameters:@"" success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.failTime > 0 ? (self.failTime -= 1) : (self.failTime = 0);
        [self getInfoFromChain:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.failTime += 1;
        if (self.failTime <= maxFailTime) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self lookingForSeed];
            });
        }
    }];
}

- (void)getInfoFromChain:(NSArray*)arr{
    
    if (![arr isKindOfClass:[NSArray class]]) {
        return;
    }
    
    for (NSDictionary *dic in arr) {
        NeoNodeObject *node = [[NeoNodeObject alloc] init];
        if ([dic.allKeys containsObject:@"height"] && [dic.allKeys containsObject:@"url"]) {
            node.height = ((NSNumber*)dic[@"height"]).integerValue;
            node.url = dic[@"url"];

        }
        if (self.maxBlockChain <= node.height) {
            self.maxBlockChain = node.height;
        }
        [self.nodesArr addObject:node];
    }
    
    [self reconfirmValidation];
}

- (void)reconfirmValidation{
    for (NeoNodeObject *node in self.nodesArr) {
        if (node.height >= self.maxBlockChain) {
            [self.seedsArr addObject:node.url];
        }
    }
    NSLog(@"seeds update seccessful");
}

#pragma mark - setter getter
- (NSMutableArray *)nodesArr{
    if (!_nodesArr) {
        _nodesArr = [NSMutableArray array];
    }
    return _nodesArr;
}

- (NSMutableArray *)seedsArr{
    if (!_seedsArr) {
        _seedsArr = [NSMutableArray array];
    }
    return _seedsArr;
}

- (AFHTTPSessionManager *)neoScanManager{
    if (!_neoScanManager) {
        _neoScanManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://neoscan.io/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _neoScanManager;
}
@end
