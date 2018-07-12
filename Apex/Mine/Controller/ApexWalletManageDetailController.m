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


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseVHeight;

@property (nonatomic, strong) UIButton *saveBtn;
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
}

//- (void)requestBalance{
//    @weakify(self);
//    [ApexWalletManager getAccountStateWithAddress:self.model.address Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        @strongify(self);
//        ApexAccountStateModel *model = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
//        model.balances.count == 0 ? (self.balanceL.text = @"0") : (self.balanceL.text = model.balances.firstObject.value);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        self.balanceL.text = @"N/A";
//    }];
//}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSString *name = self.walletNameTF.text;
        if (name.length == 0 ) {
            [self showMessage:SOLocalizedStringFromTable(@"Please Input Wallet Name", nil)];
            return;
        }
        
        [ApexWalletManager changeWalletName:name forAddress:self.model.address];
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
        [ApexPassWordConfirmAlertView showEntryPasswordAlertAddress:self.model.address subTitle:@"" Success:^(NeomobileWallet *wallet) {
            ApexExportKeyStoreController *vc = [[ApexExportKeyStoreController alloc] init];
            vc.address = self.model.address;
            [self.navigationController pushViewController:vc animated:YES];
        } fail:^{
            [self showMessage:SOLocalizedStringFromTable(@"Password Error", nil)];
        }];
    }];
}

- (void)showDeleteConfirmAlert{
    [ApexPassWordConfirmAlertView showDeleteConfirmAlertAddress:self.model.address subTitle:SOLocalizedStringFromTable(@"Attention! Delete Wallet Can Not Be Revoked", nil) Success:^(NeomobileWallet *wallet) {
        [ApexWalletManager deleteWalletForAddress:self.model.address];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^{
        [self showMessage:SOLocalizedStringFromTable(@"Password Error",nil)];
    }];
}

#pragma mark - ------getter & setter------
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setTitle:SOLocalizedStringFromTable(@"Save", nil) forState:UIControlStateNormal];
    }
    return _saveBtn;
}
@end
