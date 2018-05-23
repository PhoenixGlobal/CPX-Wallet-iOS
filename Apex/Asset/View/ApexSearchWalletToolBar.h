//
//  ApexSearchWalletToolBar.h
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexSearchWalletToolBar : UIView
@property (nonatomic, strong) RACSubject *textDidChangeSub;

- (void)clearEntrance;
@end
