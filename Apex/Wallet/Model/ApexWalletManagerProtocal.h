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
- (id)saveWallet:(NSString*)address name:(NSString*)name;;
- (void)changeWalletName:(NSString*)name forAddress:(NSString*)address;
- (id)getWalletsArr; /**< string : address/name */
- (void)deleteWalletForAddress:(NSString*)address;
- (void)setBackupFinished:(NSString*)address;
- (void)setStatus:(BOOL)status forWallet:(NSString *)address;
- (BOOL)getWalletTransferStatusForAddress:(NSString*)address;
- (void)updateWallet:(id)wallet WithAssetsArr:(NSMutableArray<BalanceObject*>*)assetArr;
- (ApexTransferStatus)transferStatusForAddress:(NSString*)address;
- (void)reSortAssetArr:(NSMutableArray*)assetArr;

- (ApexAssetModel*)assetModelByBalanceModel:(BalanceObject*)balanceObj;

//extends
- (void)WalletFromKeystore:(NSString*)ks password:(NSString*)passWord success:(void (^)(id wallet))success failed:(void (^)(NSError *error))failed;
@end
