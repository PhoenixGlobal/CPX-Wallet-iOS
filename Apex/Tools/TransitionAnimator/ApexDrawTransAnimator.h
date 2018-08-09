//
//  ApexDrawTransAnimator.h
//  Apex
//
//  Created by chinapex on 2018/6/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <CYLAppBaseFrameWork/CYLAppBaseFrameWork.h>
#import "ApexDrawTransPercentDriven.h"

//侧滑出来的距离
#define delta 150

@interface ApexDrawTransAnimator : CYLBaseTransitionAnimation
@property (nonatomic, strong) UIView *fakeView;

- (void)clearRedundentView;
@end
