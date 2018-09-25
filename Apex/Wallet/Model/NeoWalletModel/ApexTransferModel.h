//
//  ApexTransferStatusModel.h
//  Apex
//
//  Created by chinapex on 2018/6/21.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 assetId = 0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b;
 decimal = "<null>";
 from = AQVh2pG732YvtNaxEGkQUei3YA4cvo7d2i;
 "gas_consumed" = "<null>";
 imageURL = "todo_imageURL";
 symbol = "todo_symbol";
 time = 1476724549;
 to = Ae2d6qj91YL3LVUMkza7WQsaTYjzjHm4z1;
 txid = 0xee85d489e4428a538f39c1903771e1f222a383f8327c96ed19cc02079149a1fd;
 type = NEO;
 value = "+1000";
 vmstate = "<null>";
 */

@interface ApexTransferModel : NSObject
@property (nonatomic, assign) ApexTransferStatus status; /**< 此笔交易的状态 */
@property (nonatomic, strong) NSString *nonce; /**< eth特有 暂时未写入数据库 */

@property (nonatomic, strong) NSString *gas_consumed; //花费的gas数
@property (nonatomic, strong) NSString *vmstate; /**< 交易成功还是失败  失败的含有FAULT字段 */
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

//新加字段
@property (nonatomic, assign) NSString *block_number; /**< 此笔交易所在的区块高度 */
@property (nonatomic, strong) NSString *gas_price; /**< gas单价*/
@property (nonatomic, strong) NSString *gas_fee; /**< 矿工fee */
@end

NS_ASSUME_NONNULL_END
