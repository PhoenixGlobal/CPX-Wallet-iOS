//
//  ApexSearchWalletToolBar.h
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexSearchWalletToolBar : UIView
@property (nonatomic, strong) RACSubject *textDidChangeSub;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) UIImage *searchTFLeftImage;


- (void)setPlaceHolder:(NSString *)placeHolder color:(UIColor*)color;
- (void)setTextColor:(UIColor*)textColor backgroundColor:(UIColor*)bgColor;
- (void)setLeftView:(UIView*)leftView;
- (void)clearEntrance;
- (void)setTFBackColor:(UIColor*)color;
- (void)setCancleBtnImage:(UIImage*)image;
@end
