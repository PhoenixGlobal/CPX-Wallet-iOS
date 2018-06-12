//
//  ApexSendMoneyViewModel.m
//  Apex
//
//  Created by chinapex on 2018/5/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSendMoneyViewModel.h"
#import <AFHTTPSessionManager.h>

@implementation ApexSendMoneyViewModel
- (void)getUtxoSuccess:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock{
    [CYLNetWorkManager GET:@"utxos/" parameter:@{@"address":self.address} success:successBlock fail:failBlock];
}
@end
