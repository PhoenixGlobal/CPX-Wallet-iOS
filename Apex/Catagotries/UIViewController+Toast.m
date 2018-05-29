//
//  UIViewController+Toast.m
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/8/17.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "UIViewController+Toast.h"
#import <objc/runtime.h>

static const char* hudKey = "hudKey";

@implementation UIViewController (Toast)

- (void)showMessage:(NSString *)message WithDelay:(NSInteger)delay{
    //初始化进度框，置于当前的View当中
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //设置对话框文字
    HUD.detailsLabel.text = message;
    HUD.mode = MBProgressHUDModeText;
    
    //显示对话框
    [HUD showAnimated:YES];
    
    [HUD hideAnimated:YES afterDelay:delay];
}

- (void)showMessage:(NSString *)message
{
    //初始化进度框，置于当前的View当中
   MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //设置对话框文字
    HUD.detailsLabel.text = message;
    HUD.mode = MBProgressHUDModeText;
    
    //显示对话框
    [HUD showAnimated:YES];
    
    [HUD hideAnimated:YES afterDelay:1];
}

- (void)showMessageOnWindow:(NSString *)message
{
    //初始化进度框，置于当前的View当中
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    //设置对话框文字
    HUD.detailsLabel.text = message;
    HUD.mode = MBProgressHUDModeText;
    
    //显示对话框
    [HUD showAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideAnimated:YES];
        [HUD removeFromSuperview];
    });
}

- (MBProgressHUD *)hud
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    return hud;
//    return objc_getAssociatedObject(self, hudKey);
}

- (void)setHud:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(hud, &hudKey, self, OBJC_ASSOCIATION_RETAIN);
}

@end
