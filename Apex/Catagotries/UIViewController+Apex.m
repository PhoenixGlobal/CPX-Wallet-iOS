//
//  UIViewController+Apex.m
//  Apex
//
//  Created by chinapex on 2018/6/6.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "UIViewController+Apex.h"

@implementation UIViewController (Apex)
- (void)directlyPushToViewControllerWithSelfDeleted:(UIViewController*)vc{
    NSMutableArray *viewCtrs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSInteger index = [viewCtrs indexOfObject:self];
    NSInteger i = viewCtrs.count;
    i--;
    for(; i>=index; i--){
        [viewCtrs removeObjectAtIndex:i];
    }
    [viewCtrs addObject:vc];
    [self.navigationController setViewControllers:viewCtrs animated:YES];
}
@end
