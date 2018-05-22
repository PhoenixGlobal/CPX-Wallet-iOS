//
//  UIViewController+Toast.h
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/8/17.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface UIViewController (Toast)
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)showMessage:(NSString *)message WithDelay:(NSInteger)delay;

- (void)showMessage:(NSString*)message;

- (void)showMessageOnWindow:(NSString *)message;
@end
