//
//  ApexSwithWalletView.h
//  Apex
//
//  Created by chinapex on 2018/5/31.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexSwithWalletView : UIView
@property (nonatomic, strong) NSArray *contentArr;
@property (nonatomic, strong) RACSubject *didSwitchSub;
@end
