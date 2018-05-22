//
//  UIViewController+NetLoadIndicator.m
//  Apex
//
//  Created by chinapex on 2018/5/7.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "UIViewController+NetLoadIndicator.h"
#import <MBProgressHUD.h>

#define maxTime 15

@implementation UIViewController (NetLoadIndicator)
- (void)showHUD{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.graceTime = 0.2;
    hud.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUD];
    });
}

- (void)hideHUD{
    if ([MBProgressHUD HUDForView:self.view]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)showHUDOnWindow{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.graceTime = 0.2;
    hud.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUDFromWindow];
    });
}

- (void)hideHUDFromWindow{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if ([MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
@end
