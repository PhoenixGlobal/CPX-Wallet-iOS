//
//  ApexPrepareBackUpController.m
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexPrepareBackUpController.h"
#import "ApexBackUpController.h"
#import "ApexPassWordConfirmAlertView.h"

@interface ApexPrepareBackUpController ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *tipL;
@property (nonatomic, strong) UILabel *detailL;
@property (nonatomic, strong) UIButton *toBackUpBtn;
@end

@implementation ApexPrepareBackUpController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[ApexUIHelper mainThemeColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)initUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (_isFromCreat) {
        self.title = SOLocalizedStringFromTable(@"Create Wallet", nil);
    }else{
        self.title = SOLocalizedStringFromTable(@"Backup Wallet", nil);
    }
    
    [self.view addSubview:self.imageV];
    [self.view addSubview:self.tipL];
    [self.view addSubview:self.detailL];
    [self.view addSubview:self.toBackUpBtn];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(NavBarHeight + scaleHeight667(48));
        make.width.mas_equalTo(43);
        
        if (@available(iOS 11.0, *)) {
            make.height.mas_equalTo(52);
        }else{
            make.height.mas_equalTo(52+NavBarHeight);
        }
    }];
    
    [self.tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipL.mas_bottom).offset(scaleHeight667(44));
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.greaterThanOrEqualTo(self.view).offset(35);
        make.right.greaterThanOrEqualTo(self.view).offset(-35);
    }];
    
    [self.toBackUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(305));
        make.height.mas_equalTo(40);
        make.top.equalTo(self.view.mas_bottom).offset(scaleHeight667(-100));
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.toBackUpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [ApexPassWordConfirmAlertView showDeleteConfirmAlertAddress:self.address subTitle:@"" Success:^(NeomobileWallet *wallet) {
            NSError *err = nil;
            ApexBackUpController *vc = [[ApexBackUpController alloc] init];
            vc.address = self.address;
            vc.mnemonic = [wallet mnemonic:mnemonicEnglish error:&err];
            vc.BackupCompleteBlock = self.BackupCompleteBlock;
            if (err) {
                [self showMessage:SOLocalizedStringFromTable(@"Create Mnemonics Failed", nil)];
                return;
            }
            [self.navigationController pushViewController:vc animated:YES];
        } fail:^{
            [self showMessage:SOLocalizedStringFromTable(@"Create Mnemonics Failed", nil)];
        }];
        
        
    }];
}

#pragma mark - ------getter & setter------
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 2"]];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageV;
}

- (UILabel *)tipL{
    if (!_tipL) {
        _tipL = [[UILabel alloc] init];
        _tipL.font = [UIFont systemFontOfSize:18];
        _tipL.text = SOLocalizedStringFromTable(@"Backup Wallet", nil);
        _tipL.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _tipL;
}

- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc] init];
        _detailL.font = [UIFont systemFontOfSize:13];
        _detailL.text = SOLocalizedStringFromTable(@"Export mnemonics and keep it in a safe place, do not save on the internet. then begin using with transfer small assets.", nil);
        _detailL.numberOfLines = 0;
        _detailL.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _detailL;
}

- (UIButton *)toBackUpBtn{
    if (!_toBackUpBtn) {
        _toBackUpBtn = [[UIButton alloc] init];
        [_toBackUpBtn setTitle:SOLocalizedStringFromTable(@"Backup Wallet", nil) forState:UIControlStateNormal];
        [_toBackUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _toBackUpBtn.backgroundColor = [ApexUIHelper mainThemeColor];
        _toBackUpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _toBackUpBtn.layer.cornerRadius = 6;
        
    }
    return _toBackUpBtn;
}
@end
