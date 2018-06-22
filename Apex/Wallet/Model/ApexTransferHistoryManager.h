//
//  ApexTransferHistoryManager.h
//  Apex
//
//  Created by chinapex on 2018/6/22.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApexTransferModel;

@interface ApexTransferHistoryManager : NSObject
singleH(Manager);
- (void)createTableForWallet:(NSString*)walletAddress;
- (void)addTransferHistory:(ApexTransferModel*)model forWallet:(NSString*)walletAddress;
- (void)updateTransferStatus:(ApexTransferStatus)status forTXID:(NSString*)txid ofWallet:(NSString*)walletAddress;
- (NSMutableArray*)getAllTransferHistoryForAddress:(NSString*)address;
@end
