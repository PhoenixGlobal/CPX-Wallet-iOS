//
//  ZJNHUDTipsView.m
//  ZhujianniaoUser2.0
//
//  Created by 迟钰林 on 2017/8/18.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "ZJNHUDTipsView.h"

@implementation ZJNHUDTipsView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.refereshBtn.layer.cornerRadius = 3;
    self.refereshBtn.layer.borderColor = [ApexUIHelper mainThemeColor].CGColor;
    self.refereshBtn.layer.borderWidth = 1;
}

@end
