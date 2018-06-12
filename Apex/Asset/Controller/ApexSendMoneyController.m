//
//  ApexSendMoneyController.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexSendMoneyController.h"
#import "ApexTXIDModel.h"
#import "ApexTXRecorderModel.h"
#import "ApexSendMoneyViewModel.h"
#import "LXDScanCodeController.h"
#import "ApexPassWordConfirmAlertView.h"

@interface ApexSendMoneyController ()<LXDScanCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *walletNameL;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressL;
@property (weak, nonatomic) IBOutlet UITextField *sendNumTF;
@property (weak, nonatomic) IBOutlet UITextField *toAddressTF;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) ApexSendMoneyViewModel *viewModel;
@property (nonatomic, strong) NSNumber *confirmBlock;
@property (nonatomic, strong) ApexTXIDModel *txidModel;
@property (nonatomic, strong) NeomobileWallet *wallet;
@end

@implementation ApexSendMoneyController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor colorWithRed255:70 green255:105 blue255:214 alpha:1]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)setUI{
    self.title = @"转账";
    self.unitL.text = self.unit;
    self.walletNameL.text = self.walletName;
    self.fromAddressL.text = self.walletAddress;
    self.toAddressTF.text = self.toAddressIfHave;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanBtn];
    
    [ApexUIHelper addLineInView:self.sendNumTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    self.sendBtn.layer.cornerRadius = 6;
}

- (void)utxoSearch:(NeomobileWallet*)wallet{
    if (_toAddressTF.text.length == 0) {
        [self showMessage:@"请填写转账地址"];
        return;
    }
    
    self.wallet = wallet;
    if (!self.wallet) {
        [self showMessage:@"钱包开启失败"];
        return;
    }
    
    @weakify(self);
    [self.viewModel getUtxoSuccess:^(CYLResponse *response) {
        @strongify(self);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *unspendArr = dict[@"result"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:unspendArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *unspendStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError *err = nil;
        NeomobileTx *tx = [self.wallet createAssertTx:self.balanceModel.asset from:self.walletAddress to:self.toAddressTF.text amount:self.sendNumTF.text.doubleValue unspent:unspendStr error:&err];
        if (err) {
            [self showMessage:@"tx生成失败"];
        }else{
            [self broadCastTransaction:tx];
        }
        
    } fail:^(NSError *error) {
        [self showMessage:@"utxo获取失败"];
    }];
}

- (void)broadCastTransaction:(NeomobileTx*)tx{
    [ApexWalletManager broadCastTransactionWithData:tx.data Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL isSuccess = ((NSNumber*)responseObject).boolValue;
        if (isSuccess) {
            [self showMessage:@"广播交易成功"];
            ApexTXRecorderModel *txRecordModel = [[ApexTXRecorderModel alloc] init];
            txRecordModel.txid = tx.id_;
            txRecordModel.fromAddress = self.fromAddressL.text;
            txRecordModel.toAddress = self.toAddressTF.text;
            txRecordModel.value = self.sendNumTF.text;
            txRecordModel.data = tx.data;
            float timestamp = [[NSDate date] timeIntervalSince1970];
            txRecordModel.timeStamp = [NSString stringWithFormat:@"%f",timestamp];
            [self saveTX:txRecordModel];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self showMessage:@"广播交易失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMessage:@"广播交易失败,请检查网络连接"];
    }];
}

- (void)saveTX:(ApexTXRecorderModel*)model{
    NSMutableArray *arr = [TKFileManager loadDataWithFileName:TXRECORD_KEY];
    if (arr == nil) {
        arr = [NSMutableArray array];
    }
    
    [arr addObject:model];
    
    [TKFileManager saveData:arr withFileName:TXRECORD_KEY];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo{

    NSString *toaddress = codeInfo;
    self.toAddressTF.text = toaddress;
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        LXDScanCodeController *scanvc = [[LXDScanCodeController alloc] init];
        scanvc.scanDelegate = self;
        [self.navigationController pushViewController:scanvc animated:YES];
    }];
}

- (IBAction)sendAction:(id)sender {
    [ApexPassWordConfirmAlertView showEntryPasswordAlertAddress:_walletAddress subTitle:@"" Success:^(NeomobileWallet *wallet) {
       [self utxoSearch:wallet];
    } fail:^{
        [self showMessage:@"密码输入错误"];
    }];
}
#pragma mark - ------getter & setter------
- (ApexSendMoneyViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ApexSendMoneyViewModel alloc] init];
        _viewModel.address = self.walletAddress;
    }
    return _viewModel;
}

- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_scanBtn setImage:[UIImage imageNamed:@"Group 3-3"] forState:UIControlStateNormal];
    }
    return _scanBtn;
}
@end
