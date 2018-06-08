//
//  CYLNavBaseController.m
//  Apex
//
//  Created by chinapex on 2018/5/4.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "CYLNavBaseController.h"
#import "ApexMorePanelController.h"

@interface CYLNavBaseController ()<UIGestureRecognizerDelegate>

@end

@implementation CYLNavBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor* color = [UIColor whiteColor];
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes= dict;
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        return NO;
    }else{
        
        if ([self.topViewController isKindOfClass:[ApexMorePanelController class]]) {
            return NO;
        }else{
            return YES;
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count != 0) {
        
        [self.navigationBar setTintColor:[UIColor whiteColor]];
        UIImage *image = [UIImage imageNamed:@"back-w"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        
    }
    [self findHairlineImageViewUnder:self.navigationBar].hidden = YES;
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
