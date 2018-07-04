//
//  ApexSheetView.m
//  Apex
//
//  Created by chinapex on 2018/7/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexSheetView.h"

@interface ApexSheetView()
@property (nonatomic, strong) UIView *coverView;
@end

@implementation ApexSheetView
+ (void)showApexSheetWithTitle:(NSString *)title sheetHandlers:(NSArray<ApexSheetHandler *> *)handlers{
    ApexSheetView *sheet = [[ApexSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
}

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_coverView];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end


@implementation ApexSheetHandler

+ (instancetype)handlerWithTitle:(NSString *)title style:(ApexSheetHandlerStyle)style handler:(sheetHandler)handler{
    ApexSheetHandler *sheetHandler = [[ApexSheetHandler alloc] init];
    sheetHandler.title = title;
    sheetHandler.handler = handler;
    sheetHandler.style = style;
    
    switch (style) {
        case ApexSheetHandlerStyle_Default:
            sheetHandler.titleColor = [UIColor blueColor];
            break;
            
        case ApexSheetHandlerStyle_Cancle:
            sheetHandler.titleColor = [UIColor redColor];
            break;
    }
    
    return sheetHandler;
}

@end
