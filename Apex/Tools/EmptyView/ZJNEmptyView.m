//
//  ZJNEmptyView.m
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/8/7.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "ZJNEmptyView.h"
#import "ZJNHUDTipsView.h"

@interface ZJNEmptyView ()

@property (nonatomic, strong) ZJNHUDTipsView *hudView;
@end

@implementation ZJNEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.hudView = [[NSBundle mainBundle] loadNibNamed:@"ZJNHUDTipsView" owner:nil options:0].firstObject;
    _hud = [self viewWithTag:123];
    if (!_hud) {
        _hud = [self installHUD];
    }
    self.backgroundColor = [UIColor whiteColor];
    
    [[[self.hudView.refereshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x){
        if (self.refereshBlock) {
            self.refereshBlock();
        }
    }];
}

- (MBProgressHUD *)installHUD{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:NO];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = self.hudView;
    hud.opacity = 0;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.labelColor = [UIColor grayColor];
    hud.yOffset = -0.05 * self.bounds.size.height;
    
    hud.removeFromSuperViewOnHide = YES;
    hud.tag = 123;
    return hud;
}

+ (instancetype)showEmptyViewOnView:(UIView *)view emptyType:(ZJNEmptyType)type message:(NSString *)message refereshBlock:(referesh)block{
    ZJNEmptyView *emptyV = [[ZJNEmptyView alloc] initWithFrame:view.bounds];
    emptyV.type = type;
    emptyV.message = message;
    emptyV.refereshBlock = block;
    [view addSubview:emptyV];
    return emptyV;
}

+ (void)hideOnView:(UIView *)view{
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[ZJNEmptyView class]]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)setType:(ZJNEmptyType)type
{
    if (type == ZJNEmptyType_dataEmpty) {
        self.hudView.imageV.image = [UIImage imageNamed:@"Page 12"];
        self.hudView.refereshBtn.hidden = YES;
    }
    else
    {
        self.hudView.imageV.image = [UIImage imageNamed:@"无网络"];
        self.hudView.refereshBtn.hidden = false;
    }
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.hudView.message.text = message;
}
@end
