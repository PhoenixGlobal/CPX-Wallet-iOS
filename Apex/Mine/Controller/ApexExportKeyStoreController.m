//
//  ApexExportKeyStoreController.m
//  Apex
//
//  Created by chinapex on 2018/6/7.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexExportKeyStoreController.h"
#import "ApexTwoSwitchView.h"
#import "ApexExportKeystoryFileView.h"
#import "ApexExportKeystoreQRView.h"

@interface ApexExportKeyStoreController ()
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) ApexTwoSwitchView *switchView;
@property (nonatomic, strong) ApexExportKeystoreQRView *QRView;
@property (nonatomic, strong) ApexExportKeystoryFileView *fileView;
@end

@implementation ApexExportKeyStoreController
#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - ------private------
- (void)initUI{
    
    self.title = @"导出keystore";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.QRView];
    [self.view addSubview:self.fileView];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backIV);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    self.switchView.hidden = YES;
    
    [self.QRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIV.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.QRView);
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_SwitchViewChooseLeft]) {
        self.fileView.hidden = NO;
        self.QRView.hidden = YES;
    }else if ([eventName isEqualToString:RouteNameEvent_SwitchViewChooseRight]){
        self.QRView.hidden = NO;
        self.fileView.hidden = YES;
    }
}

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

- (ApexExportKeystoreQRView *)QRView{
    if (!_QRView) {
        _QRView = [[NSBundle mainBundle] loadNibNamed:@"ApexExportKeystoreQRView" owner:nil options:@{}].firstObject;
        _QRView.address = self.address;
    }
    return _QRView;
}

- (ApexExportKeystoryFileView *)fileView{
    if (!_fileView) {
        _fileView = [[NSBundle mainBundle] loadNibNamed:@"ApexExportKeystoryFileView" owner:nil options:@{}].firstObject;
        _fileView.address = self.address;
    }
    return _fileView;
}
@end
