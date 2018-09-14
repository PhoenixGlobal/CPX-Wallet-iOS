//
//  ReformerProtocol.h
//  CYLNetWorkManager
//
//  Created by chinapex on 2018/4/2.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYLApiBaseManager;

@protocol ReformerProtocol <NSObject>
- (id)reformDataWithManager:(CYLApiBaseManager*)apiManager;
@end
