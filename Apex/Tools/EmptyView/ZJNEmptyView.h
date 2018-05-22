//
//  ZJNEmptyView.h
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/8/7.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZJNEmptyType) {
    ZJNEmptyType_dataEmpty,
    ZJNEmptyType_netError
};

typedef void(^referesh)();

@interface ZJNEmptyView : UIView
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) ZJNEmptyType type;
@property (nonatomic, copy) referesh refereshBlock;
@property (nonatomic, strong) MBProgressHUD *hud;

+ (instancetype)showEmptyViewOnView:(UIView*)view emptyType:(ZJNEmptyType)type message:(NSString*)message refereshBlock:(referesh)block;
+ (void)hideOnView:(UIView*)view;
@end
