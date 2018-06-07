//
//  ApexExportKeyStoreController.m
//  Apex
//
//  Created by chinapex on 2018/6/7.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexExportKeyStoreController.h"
#import "ApexTwoSwitchView.h"

@interface ApexExportKeyStoreController ()
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) ApexTwoSwitchView *switchView;
@end

@implementation ApexExportKeyStoreController
#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - ------private------
- (void)initUI{
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.switchView];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight+40);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backIV);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------


#pragma mark - ------getter & setter------
- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] init];
        _backIV.image = [UIImage imageNamed:@"Background"];
    }
    return _backIV;
}

- (ApexTwoSwitchView *)switchView{
    if (!_switchView) {
        _switchView = [[ApexTwoSwitchView alloc] init];
        [_switchView.leftBtn setTitle:@"keystore文件" forState:UIControlStateNormal];
        [_switchView.rightBtn setTitle:@"二维码" forState:UIControlStateNormal];
    }
    return _switchView;
}
@end
