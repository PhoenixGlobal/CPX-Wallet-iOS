//
//  ApexAssetMainViewCell.h
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexAccountStateModel.h"

@interface ApexAssetMainViewCell : UITableViewCell
@property (weak, nonatomic) NSString *walletNameStr;
@property (weak, nonatomic) NSString *addressStr;
@property (nonatomic, strong) RACSubject *didFinishRequestBalanceSub;
@property (nonatomic, assign) BOOL isShowSlide;
//- (ApexAccountStateModel*)getAccountInfo;
@end
