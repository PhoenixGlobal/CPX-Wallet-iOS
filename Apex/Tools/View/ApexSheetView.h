//
//  ApexSheetView.h
//  Apex
//
//  Created by chinapex on 2018/7/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ApexSheetHandler;
@interface ApexSheetView : UIView
+ (void)showApexSheetWithTitle:(NSString*)title sheetHandlers:(NSArray<ApexSheetHandler*>*)handlers;
@end

NS_ASSUME_NONNULL_END


typedef void(^sheetHandler)(void);
typedef NS_ENUM(NSInteger, ApexSheetHandlerStyle) {
    ApexSheetHandlerStyle_Default,
    ApexSheetHandlerStyle_Cancle
};

@interface ApexSheetHandler : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) sheetHandler handler;
@property (nonatomic, assign) ApexSheetHandlerStyle style;

+ (instancetype)handlerWithTitle:(NSString*)title style:(ApexSheetHandlerStyle)style handler:(sheetHandler)handler;
@end
