//
//  ApexTXIDModel.h
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "txid": "0x314864d21af84cdcfc4fb09b730fba60408100634eec1dcc5551e5608ee45762",
 "size": 262,
 "type": "ContractTransaction",
 "version": 0,
 "attributes": [],
 "vin": [
 {
 "txid": "0xa976fe69a563f429485d0732016b6c939cf2dab13aaac01f07ee20aa70847457",
 "vout": 0
 }
 ],
 "vout": [
 {
 "n": 0,
 "asset": "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
 "value": "1",
 "address": "ARF9CNWdtpWZhMBvsbRd3jo12s4YcfeQyR"
 },
 {
 "n": 1,
 "asset": "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
 "value": "2",
 "address": "AJGGeNK7JrVBH9JVfxgwCekfkywE8AR3kh"
 }
 ]
 */
@interface ApexTXIDModel : NSObject
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSArray *vin;
@property (nonatomic, strong) NSArray *vout;
@property (nonatomic, strong) NSString *blockhash;
@property (nonatomic, strong) NSString *blocktime;
@end

@interface VinObject : NSObject
@property (nonatomic, strong) NSString *txid;
@property (nonatomic, strong) NSString *vout;
@end

@interface VoutObject : NSObject
@property (nonatomic, strong) NSString *n;
@property (nonatomic, strong) NSString *asset;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *address;
@end
