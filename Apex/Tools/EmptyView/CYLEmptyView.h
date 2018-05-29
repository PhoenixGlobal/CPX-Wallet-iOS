//
//  CYLEmptyView.h
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CYLEmptyViewType) {
    CYLEmptyViewType_NetERROR = 10030,
    CYLEmptyViewType_EmptyData
};

@interface CYLEmptyView : UIView

+ (instancetype)showEmptyViewOnView:(UIView*)superView emptyType:(CYLEmptyViewType)type message:(NSString*)message refreshBlock:(dispatch_block_t)block;

+ (instancetype)showEmptyViewOnView:(UIView*)superView y_offSet:(CGFloat)offsetY emptyType:(CYLEmptyViewType)type message:(NSString*)message refreshBlock:(dispatch_block_t)block;

@end
