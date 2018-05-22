//
//  ApexWalletManager.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWalletManager.h"

@implementation ApexWalletManager
+ (void)saveWallet:(NSString *)wallet{
    NSMutableArray *arr = [TKFileManager loadDataWithFileName:walletsKey];
    if (!arr) {
        arr = [NSMutableArray array];
    }
    
    [arr addObject:wallet];
    [TKFileManager saveData:arr withFileName:walletsKey];
}

+ (id)getWalletsArr{
    return [TKFileManager loadDataWithFileName:walletsKey];
}
@end
