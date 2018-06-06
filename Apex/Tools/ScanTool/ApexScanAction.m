//
//  ApexScanAction.m
//  Apex
//
//  Created by chinapex on 2018/6/6.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexScanAction.h"
#import <AVFoundation/AVFoundation.h>
#import "LXDScanCodeController.h"
#import "ApexSendMoneyController.h"

@interface ApexScanAction()<LXDScanCodeControllerDelegate>
@property (nonatomic, strong) UIViewController *fromVC;
@property (nonatomic, strong) UINavigationController *navVC;
@end

@implementation ApexScanAction
singleM(ScanHelper);
+ (void)scanActionOnViewController:(UIViewController *)vc{
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有相机访问权限" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“”打开相机访问权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [vc presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    LXDScanCodeController * scanCodeController = [LXDScanCodeController scanCodeController];
    scanCodeController.hidesBottomBarWhenPushed = YES;
    scanCodeController.scanDelegate = [ApexScanAction shareScanHelper];
    [ApexScanAction shareScanHelper].fromVC = vc;
    [ApexScanAction shareScanHelper].navVC = vc.navigationController;
    [vc directlyPushToViewControllerWithSelfDeleted:scanCodeController];
}

#pragma mark - ------delegate-----
- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo{
    NSString *toaddress = codeInfo;
    
    ApexSendMoneyController *svc = [[ApexSendMoneyController alloc] init];
    svc.walletAddress = self.curWallet.address;
    svc.walletName = self.curWallet.name;
    svc.toAddressIfHave = toaddress;
    NSEnumerator *enumerator = self.navVC.childViewControllers.reverseObjectEnumerator;
    UIViewController *vc = nil;
    while (vc = [enumerator nextObject]) {
        if (![vc isKindOfClass:LXDScanCodeController.class]) {
            break;
        }
    }
    [vc.navigationController pushViewController:svc animated:YES];
}
@end
