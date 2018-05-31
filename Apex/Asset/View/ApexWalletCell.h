//
//  ApexWalletCell.h
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexAccountStateModel.h"

@interface ApexWalletCell : UICollectionViewCell
@property (weak, nonatomic) NSString *walletNameStr;
@property (weak, nonatomic) NSString *addressStr;
@property (nonatomic, strong) RACSubject *didFinishRequestBalanceSub;
@property (nonatomic, assign) BOOL isShowSlide;
- (ApexAccountStateModel*)getAccountInfo;
@end
