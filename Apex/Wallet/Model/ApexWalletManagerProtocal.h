//
//  ApexWalletManagerProtocal.h
//  Apex
//
//  Created by yulin chi on 2018/8/15.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BalanceObject;
@class ApexAssetModel;

@protocol ApexWalletManagerProtocal <NSObject>
//存储钱包
- (id)saveWallet:(NSString*)address name:(NSString*)name;
//改变钱包的名字
- (void)changeWalletName:(NSString*)name forAddress:(NSString*)address;
//获得全部钱包模型数组
- (id)getWalletsArr; /**< string : address/name */
//删除钱包
- (void)deleteWalletForAddress:(NSString*)address;
//设置钱包是否备份过
- (void)setBackupFinished:(NSString*)address;
//设置钱包的交易状态 是否允许交易
- (void)setStatus:(BOOL)status forWallet:(NSString *)address;
//获得钱包当前的交易状态
- (BOOL)getWalletTransferStatusForAddress:(NSString*)address;
//跟新钱包的资产模型数组
- (void)updateWallet:(id)wallet WithAssetsArr:(NSMutableArray<BalanceObject*>*)assetArr;
//钱包当前交易所处状态
- (ApexTransferStatus)transferStatusForAddress:(NSString*)address;
//重拍资产列表数组
- (void)reSortAssetArr:(NSMutableArray*)assetArr;
//banlance模型转资产模型方法
- (ApexAssetModel*)assetModelByBalanceModel:(BalanceObject*)balanceObj;

//extends
- (void)WalletFromKeystore:(NSString*)ks password:(NSString*)passWord success:(void (^)(id wallet))success failed:(void (^)(NSError *error))failed;
@end
