//
//  ApexAlertTextField.h
//  Apex
//
//  Created by chinapex on 2018/5/29.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "JVFloatLabeledTextField.h"

typedef BOOL(^isShowAlertBlock)(NSString *text);

@interface ApexAlertTextField : JVFloatLabeledTextField
@property (nonatomic, strong) NSString *alertString;
@property (nonatomic, copy) isShowAlertBlock alertShowConditionBlock;
@property (nonatomic, assign) BOOL isHiddenBottomLine;
@property (nonatomic, assign) BOOL isAlertShowing;
@end
