//
//  ApexWalletSelectTypeView.h
//  Apex
//
//  Created by yulin chi on 2018/8/13.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, ApexWalletType) {
    ApexWalletType_Neo,
    ApexWalletType_Eth
};

@interface ApexWalletSelectTypeView : UIView
@property (nonatomic, strong) UITextField *typeTF; /**<  */
@property (nonatomic, strong) RACSubject *didChooseTypeSub; /**<  */
@property (nonatomic, assign) ApexWalletType type; /**<  */
@end
