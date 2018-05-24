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

@interface ApexWalletManageDetailController ()
@property (weak, nonatomic) IBOutlet UITextField *walletNameTF;
@property (weak, nonatomic) IBOutlet UIButton *mnemonicBackUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteWalletBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation ApexWalletManageDetailController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self handleEvent];
    [self requestBalance];
}


#pragma mark - ------private------
- (void)initUI{
    [ApexUIHelper addLineInView:self.walletNameTF color:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-2, 0, 0, 0)];
    self.mnemonicBackUpBtn.layer.cornerRadius = 6;
    self.deleteWalletBtn.layer.cornerRadius = 6;
    
    self.title = self.walletNameStr;
    self.walletNameTF.text = self.walletNameStr;
    self.addressL.text = self.walletAddStr;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
}

- (void)requestBalance{
    @weakify(self);
    [ApexWalletManager getAccountStateWithAddress:self.walletAddStr Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        ApexAccountStateModel *model = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
        model.balances.count == 0 ? (self.balanceL.text = @"0") : (self.balanceL.text = model.balances.firstObject.value);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.balanceL.text = @"N/A";
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSString *name = self.walletNameTF.text;
        if (name.length == 0 ) {
            [self showMessage:@"请输入钱包名称"];
            return;
        }
        
        [ApexWalletManager changeWalletName:name forAddress:self.walletAddStr];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.deleteWalletBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self showDeleteConfirmAlert];
    }];
    
    [[self.mnemonicBackUpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApexPrepareBackUpController *vc = [[ApexPrepareBackUpController alloc] init];
        vc.address = self.walletAddStr;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)showDeleteConfirmAlert{
    [ApexPassWordConfirmAlertView showDeleteConfirmAlertAddress:self.walletAddStr subTitle:@"请慎重,此操作无法撤销" Success:^(NeomobileWallet *wallet) {
        [ApexWalletManager deleteWalletForAddress:self.walletAddStr];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^{
        [self showMessage:@"密码输入错误"];
    }];
}

#pragma mark - ------getter & setter------
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    return _saveBtn;
}
@end
