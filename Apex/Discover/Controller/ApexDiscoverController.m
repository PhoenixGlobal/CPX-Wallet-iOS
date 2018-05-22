//
//  ApexDiscoverController.m
//  Apex
//
//  Created by chinapex on 2018/5/18.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexDiscoverController.h"
#import "ZJNEmptyView.h"

@interface ApexDiscoverController ()
@property (nonatomic, strong) UIImageView *emptyV;
@property (nonatomic, strong) UILabel *tipL;
@end

@implementation ApexDiscoverController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor colorWithRed255:70 green255:105 blue255:214 alpha:1]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)setUI{
    self.title = @"发现";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self.view addSubview:self.emptyV];
    [self.view addSubview:self.tipL];
    
    [self.emptyV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.height.mas_equalTo(scaleWidth375(44));
    }];
    
    [self.tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyV.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------

#pragma mark - ------getter & setter------
- (UIImageView *)emptyV{
    if (!_emptyV) {
        _emptyV = [[UIImageView alloc] init];
        _emptyV.image = [UIImage imageNamed:@"Page 12"];
    }
    return _emptyV;
}

- (UILabel *)tipL{
    if (!_tipL) {
        _tipL = [[UILabel alloc] init];
        _tipL.text = @"暂无数据";
        _tipL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _tipL.textColor = [UIColor colorWithRed:200/255 green:200/255 blue:200/255 alpha:1];
    }
    return _tipL;
}
@end
