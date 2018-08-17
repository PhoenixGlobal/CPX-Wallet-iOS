//
//  ApexWalletManageDetailController.m
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWalletManageDetailController.h"
#import "ApexAccountStateModel.h"
#import "ApexPrepareBackUpController.h"
#import "ApexPassWordConfirmAlertView.h"
#import "ApexExportKeyStoreController.h"

@interface ApexWalletManageDetailController ()
@property (weak, nonatomic) IBOutlet UITextField *walletNameTF;
@property (weak, nonatomic) IBOutlet UIButton *mnemonicBackUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteWalletBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIButton *exportKeyStoreBtn;
@property (weak, nonatomic) IBOutlet UILabel *ksLbale;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (nonatomic, strong) id<ApexWalletManagerProtocal> walletManager; /**<  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseVHeight;
@property (nonatomic, assign) ApexWalletType walletType; /**<  */
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, assign) ApexWalletType type; /**<  */
@end

@implementation ApexWalletManageDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self handleEvent];
//    [self requestBalance];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    
    [super viewWillAppear:animated];
    if (self.model.isBackUp) {
        _mnemonicBackUpBtn.hidden = YES;
    }else{
        _mnemonicBackUpBtn.hidden = NO;
    }
}

#pragma mark - ------private------
- (void)initUI{
    [ApexUIHelper addLineInView:self.walletNameTF color:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    self.mnemonicBackUpBtn.layer.cornerRadius = 6;
    [self.mnemonicBackUpBtn setTitle:SOLocalizedStringFromTable(@"Backup Mnemonic", nil) forState:UIControlStateNormal];
    
    self.deleteWalletBtn.layer.cornerRadius = 6;
    [self.deleteWalletBtn setTitle:SOLocalizedStringFromTable(@"Delete Wallet", nil) forState:UIControlStateNormal];
    
    self.title = self.model.name;
    self.walletNameTF.text = self.model.name;
    self.addressL.text = self.model.address;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    self.baseVHeight.constant = NavBarHeight + 60;
    
    self.ksLbale.text = SOLocalizedStringFromTable(@"Export Keystore", nil);
    self.nameL.text = SOLocalizedStringFromTable(@"Wallet Name", nil);
    
    if ([_model isKindOfClass:ETHWalletModel.class]) {
        _walletManager = [ETHWalletManager shareManager];
        _type = ApexWalletType_Eth;
    }else{
        _type = ApexWalletType_Neo;
        _walletManager = [ApexWalletManager shareManager];
    }
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)handleEvent{
    @weakify(self);
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSString *name = self.walletNameTF.text;
        if (name.length == 0 ) {
            [self showMessage:SOLocalizedStringFromTable(@"Please Input Wallet Name", nil)];
            return;
        }
        
        if (name.length >8) {
            [self showMessage:SOLocalizedStringFromTable(@"longName", nil)];
             return;
        }
        
        [_walletManager changeWalletName:name forAddress:self.model.address];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.deleteWalletBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self showDeleteConfirmAlert];
    }];
    
    [[self.mnemonicBackUpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApexPrepareBackUpController *vc = [[ApexPrepareBackUpController alloc] init];
        vc.address = self.model.address;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.exportKeyStoreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [ApexPassWordConfirmAlertView showEntryPasswordAlertAddress:self.model.address walletManager:self.walletManager subTitle:@"" Success:^(id wallet) {
            ApexExportKeyStoreController *vc = [[ApexExportKeyStoreController alloc] init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        } fail:^{
            [self showMessage:SOLocalizedStringFromTable(@"Password Error", nil)];
        }];
    }];
}

- (void)showDeleteConfirmAlert{
    @weakify(self);
    [ApexPassWordConfirmAlertView showDeleteConfirmAlertAddress:self.model.address subTitle:SOLocalizedStringFromTable(@"Attention! Delete Wallet Can Not Be Revoked", nil) Success:^(NeomobileWallet *wallet) {
        
        @strongify(self);
        [_walletManager deleteWalletForAddress:self.model.address];
        
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^{
        [self showMessage:SOLocalizedStringFromTable(@"Password Error",nil)];
    }];
}

#pragma mark - ------getter & setter------
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setTitle:SOLocalizedStringFromTable(@"Confirm", nil) forState:UIControlStateNormal];
    }
    return _saveBtn;
}
@end
