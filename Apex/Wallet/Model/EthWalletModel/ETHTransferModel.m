//
//  ETHTransferModel.m
//  Apex
//
//  Created by yulin chi on 2018/9/13.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ETHTransferModel.h"
/*
 @property (nonatomic, strong) NSString *gas_consumed;
 @property (nonatomic, strong) NSString *vmstate;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *decimal;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *assetId;
 */

/*
 "blockNumber": "6268691",
 "timeStamp": "1536040499",
 "hash": "0xc3a5844a8934c1625e419c4e29dbeb2c5ff11be47ef10b4abff4bf2e75377f17",
 "nonce": "0",
 "blockHash": "0x69fef7c8e1e98c816ce91de1f83d6f54c27ad60672f7ab2a2bd52537661624c2",
 "transactionIndex": "139",
 "from": "0x77ebad3064c5ff81bc63632ea10a8a0ba4382cf5",
 "to": "0xfa1a856cfa3409cfa145fa4e20eb270df3eb21ab",
 "value": "100000000000",
 "gas": "60000",
 "gasPrice": "2530000000",
 "isError": "0",
 "txreceipt_status": "1",
 "input": "0xa9059cbb000000000000000000000000c3815b531e7f75a04ad5f4cee6d8891213b21e2a00000000000000000000000000000000000000000000001cbb3a3ff08d080000",
 "contractAddress": "",
 "cumulativeGasUsed": "7852649",
 "gasUsed": "37109",
 "confirmations": "52830"
 */
@implementation ETHTransferModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"txid" : @"hash",
//             @"vmstate" : @"txreceipt_status",
//             @"time" : @"timeStamp",
//             @"assetId" : @"contractAddress"
//             };
//}
//
//- (BOOL)yy_modelSetWithDictionary:(NSDictionary *)dic{
//
//    if ([dic.allKeys containsObject:@"gasUsed"] && [dic.allKeys containsObject:@"gasPrice"]) {
//        NSString *total = [NSString DecimalFuncWithOperatorType:2 first:dic[@"gasUsed"] secend:dic[@"gasPrice"] value:0];
//        self.gas_consumed = [NSString DecimalFuncWithOperatorType:3 first:total secend:@"1000000000000000000" value:0];
//    }
//
//    if ([dic.allKeys containsObject:@"contractAddress"]) {
//        NSString *contractAddr = dic[@"contractAddress"];
//        ApexAssetModel *contract = nil;
//        for (ApexAssetModel *model in [ETHAssetModelManage getLocalAssetModelsArr]) {
//            if ([model.hex_hash isEqualToString:contractAddr]) {
//                contract = model;
//                break;
//            }
//        }
//
//        self.type = contract.type;
//        self.decimal = contract.precision;
//        self.symbol = contract.symbol;
//        self.imageURL = contract.image_url;
//    }
//
//    return [super yy_modelSetWithDictionary:dic];
//}

@end
