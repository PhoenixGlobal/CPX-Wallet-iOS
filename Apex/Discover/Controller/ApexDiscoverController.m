//
//  ApexDiscoverController.m
//  Apex
//
//  Created by chinapex on 2018/5/18.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexDiscoverController.h"
#import "CYLEmptyView.h"
#import "ApexScrollerController.h"

@interface ApexDiscoverController ()
@end

@implementation ApexDiscoverController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[ApexUIHelper navColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)setUI{
    self.title = @"发现";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
//    [CYLEmptyView showEmptyViewOnView:self.view emptyType:CYLEmptyViewType_EmptyData message:@"暂无数据" refreshBlock:nil];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ApexScrollerController *svc = [[ApexScrollerController alloc] init];
    svc.baseColor = [ApexUIHelper navColor];
    svc.hidesBottomBarWhenPushed = YES;
    svc.firstLayerDelta = 200 - NavBarHeight;
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - ------getter & setter------

@end
