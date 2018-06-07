//
//  ApexTwoSwitchView.h
//  Apex
//
//  Created by chinapex on 2018/6/7.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RouteNameEvent_SwitchViewChooseLeft @"RouteNameEvent_SwitchViewChooseLeft"
#define RouteNameEvent_SwitchViewChooseRight @"RouteNameEvent_SwitchViewChooseRight"

@interface ApexTwoSwitchView : UIView
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end
