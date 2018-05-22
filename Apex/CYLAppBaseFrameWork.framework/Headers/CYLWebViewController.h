//
//  CYLWebViewController.h
//  CYLWebViewContainer
//
//  Created by chinapex on 2018/4/12.
//  Copyright © 2018年 Gary. All rights reserved.
//
#warning 缓存html时 需要再AFNetwork 的AFHTTPResponseSerializer类里修改 self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

#import <UIKit/UIKit.h>
@class CYLWebHandle;
@interface CYLWebViewController : UIViewController
@property (nonatomic, strong) NSArray *messageHandlerNameArr;
@property (nonatomic, strong) NSArray *jsCodeArr; /**< webview注入js代码 需要在webview初始化前设置 */
@property (nonatomic, strong) NSArray *triggerFuncFromInjectionAfterNavigationDoneArr;
@property (nonatomic, strong) NSDictionary<NSString*, CYLWebHandle*> *handlers;

@property (nonatomic, strong) NSURLRequest *request;

+(instancetype) sharedInstance;
- (void)pre_initWebView;
@end
