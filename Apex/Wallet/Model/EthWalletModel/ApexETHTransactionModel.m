//
//  ApexTransactionModel.m
//  Apex
//
//  Created by yulin chi on 2018/8/10.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexETHTransactionModel.h"

/*
 "hash":"0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b",
 "nonce":"0x",
 "blockHash": "0xbeab0aa2411b7ab17f30a99d3cb9c6ef2fc5426d6ad6fd9e2a26a6aed1d1055b",
 "blockNumber": "0x15df", // 5599
 "transactionIndex":  "0x1", // 1
 "from":"0x407d73d8a49eeb85d32cf465507dd71d507100c1",
 "to":"0x85h43d8a49eeb85d32cf465507dd71d507100c1",
 "value":"0x7f110", // 520464
 "gas": "0x7f110", // 520464
 "gasPrice":"0x09184e72a000",
 "input":"0x603880600c6000396000f300603880600c6000396000f3603880600c6000396000f360",
 */
@implementation ApexETHTransactionModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tx_hash" : @"hash",};
}

@end
