//
//  ApexAppConfig.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexAppConfig.h"
#import <IQKeyboardManager.h>
#import "ApexNetWorkCommonConfig.h"
#import <AFNetworking.h>
#import "ApexAssetModelManage.h"
#import "ApexTransferHistoryManager.h"

@implementation ApexAppConfig
+ (void) configAll{
    [self configKeyBoard];
    
    [self configBlockChainManager];
    
    [self configNetWork];
    
    [self startMonitorThread];
    
    [self updateAssetList];
    
    [self transHistorySelfCheck];
}

+ (void)transHistorySelfCheck{
    for (ApexWalletModel *wallet in [ApexWalletManager getWalletsArr]) {
        [[ApexTransferHistoryManager shareManager] applicationIntializeSelfCheckWithAddress:wallet.address];
    }
    
//    [ApexWalletManager getAccountStateWithAddress:[apex] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

+ (void)updateAssetList{
    [ApexAssetModelManage requestAssetlistSuccess:^(CYLResponse *response) {
        
    } fail:^(NSError *error) {
        
    }];
}

+ (void)startMonitorThread{
    [[ApexThread shareInstance] startRunLoopSuccessBlock:^{
        NSLog(@"apex runloop started");
    }];
}

+ (void)configBlockChainManager{
    [[ApexBlockChainManager shareSharedManager] prepare];
}

+ (void)configNetWork{
    NSString *baseUrl = [ApexNetWorkCommonConfig getToolBaseUrl];
    NSLog(@"tool baseurl: %@",baseUrl);
    [[CYLNetWorkManager shareInstance] setBaseUrl:[NSURL URLWithString:baseUrl]];
}

+ (void)configKeyBoard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

+ (void)text{
//    [ApexWalletManager getNep5AssetAccountStateWithAddress:@"ALDbmTMY54RZnLmibH3eXfHvrZt4fLiZhh" andAssetId:assetId_CPX Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    [ApexWalletManager getAssetSymbol:assetId_CPX Success:^(AFHTTPRequestOperation *operation, id resp) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *err) {
//        
//    }];
}
@end
