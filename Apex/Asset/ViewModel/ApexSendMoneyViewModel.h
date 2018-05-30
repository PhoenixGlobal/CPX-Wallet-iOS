//
//  ApexSendMoneyViewModel.h
//  Apex
//
//  Created by chinapex on 2018/5/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApexSendMoneyViewModel : NSObject
@property (nonatomic, strong) NSString *address;

- (void)getUtxoSuccess:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock;
@end
