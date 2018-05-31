//
//  ApexThread.h
//  Apex
//
//  Created by chinapex on 2018/5/31.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexThread : NSThread
singleH(Instance);

@property (nonatomic, strong) NSRunLoop *threadRunLoop;

- (void)startRunLoopSuccessBlock:(dispatch_block_t)block;
@end
