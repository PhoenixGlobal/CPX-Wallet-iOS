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
#import "ApexTransferModel.h"
#import "ApexTransferHistoryManager.h"
#import "ETHTransferHistoryManager.h"

@interface ApexSendMoneyController ()<LXDScanCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *walletNameL;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressL;
@property (weak, nonatomic) IBOutlet UITextField *sendNumTF;
@property (weak, nonatomic) IBOutlet UITextField *toAddressTF;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) UIButton *scanBtn;
@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) ApexSendMoneyViewModel *viewModel;
@property (nonatomic, strong) NSNumber *confirmBlock;
@property (nonatomic, strong) ApexTXIDModel *txidModel;
@property (nonatomic, strong) NeomobileWallet *wallet;
@property (nonatomic, strong) UIButton *backBtn;


@property (nonatomic, strong) id<ApexTransHistoryProtocal> historyManager; /**<  */

@property (weak, nonatomic) IBOutlet UILabel *availableL;
@property (weak, nonatomic) IBOutlet UIButton *takeAllBtn;

//eth
@property (weak, nonatomic) IBOutlet UIView *ethPanelView;
@property (weak, nonatomic) IBOutlet UISlider *gasSlider;
@property (weak, nonatomic) IBOutlet UILabel *gasPriceL;
@property (weak, nonatomic) IBOutlet UILabel *slowL;
@property (weak, nonatomic) IBOutlet UILabel *fastL;


@end

@implementation ApexSendMoneyController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self handleEvent];
    
    [self setNav];
}

#pragma mark - ------private------
- (void)setNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setUI{
    
    self.navigationItem.titleView = self.titleLable;
    self.walletNameL.text = self.walletName;
    self.fromAddressL.text = self.walletAddress;
    self.toAddressTF.text = self.toAddressIfHave;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanBtn];
    
    [ApexUIHelper addLineInView:self.sendNumTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    self.sendBtn.layer.cornerRadius = 6;
    self.unitL.text = [self.balanceModel getRelativeNeoAssetModel].symbol;
    
    self.slowL.text = SOLocalizedStringFromTable(@"slow", nil);
    self.fastL.text = SOLocalizedStringFromTable(@"fast", nil);
    self.toAddressTF.placeholder = SOLocalizedStringFromTable(@"SendMoneyAddress", nil);
    self.sendNumTF.placeholder = SOLocalizedStringFromTable(@"Amount", nil);
    [self.sendBtn setTitle:SOLocalizedStringFromTable(@"send", nil) forState:UIControlStateNormal];
    
    NSMutableAttributedString *attrStr = nil;
    NSString *string = @"";
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        string = [NSString stringWithFormat:@"Amount (Available: %@)",self.balanceModel.value];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }else{
        string = [NSString stringWithFormat:@"交易金额 (可用数量: %@)",self.balanceModel.value];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }
    
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([string rangeOfString:@":"].location+2, self.balanceModel.value.length)];
    self.availableL.attributedText = attrStr;
    
    [self.takeAllBtn setTitle:SOLocalizedStringFromTable(@"allMoney", nil) forState:UIControlStateNormal];
    
    NSString *minValue = [NSString DecimalFuncWithOperatorType:2 first:@"25200000000000" secend:[_balanceModel.asset isEqualToString:assetId_Eth] ? @"90000" : _balanceModel.gas value:8];
    minValue = [NSString DecimalFuncWithOperatorType:3 first:minValue secend:@"21000" value:8];
    minValue = [NSString DecimalFuncWithOperatorType:3 first:minValue secend:@"1000000000000000000" value:8];
    
    NSString *maxValue = [NSString DecimalFuncWithOperatorType:2 first:@"2520120000000000" secend:[_balanceModel.asset isEqualToString:assetId_Eth] ? @"90000" : _balanceModel.gas value:8];
    maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"21000"  value:8];
    maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"1000000000000000000" value:8];
    self.viewModel.gasSliderValue = minValue;
    
    self.gasSlider.minimumValue = minValue.doubleValue;
    self.gasSlider.maximumValue = maxValue.doubleValue;
    self.gasSlider.value = minValue.doubleValue;
}

#pragma mark - eth transaction
//- (void)ethTransactionWithWallet:(EthmobileWallet*)wallet{
//
//    if ([_balanceModel.asset isEqualToString:assetId_Eth]) {
//        //eth转账
//        [ETHWalletManager requestTransactionCount:self.fromAddressL.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [self broadEthTransactionWithNonce:responseObject wallet:wallet];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self showMessage:SOLocalizedStringFromTable(@"gainNonceFail", nil)];
//        }];
//    }else{
//        //erc20转账
//
//    }
//}
//
////eth转账
//- (void)broadEthTransactionWithNonce:(NSNumber*)nonce wallet:(EthmobileWallet*)wallet{
//    [self showHUD];
//    [ETHWalletManager sendTxWithWallet:wallet to:self.toAddressTF.text nonce:nonce.stringValue amount:self.sendNumTF.text gas:@(self.gasSlider.value).stringValue success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self hideHUD];
//        /**< 创建新的临时交易历史记录 */
//        ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
//        historyModel.txid = [responseObject hasPrefix:@"0x"] ? responseObject : [NSString stringWithFormat:@"0x%@",responseObject];
//        historyModel.from = self.fromAddressL.text;
//        historyModel.to = self.toAddressTF.text;
//        historyModel.value = [NSString stringWithFormat:@"-%@",self.sendNumTF.text];
//        historyModel.status = ApexTransferStatus_Blocking;
//        historyModel.time = @"0";
//        historyModel.assetId = self.balanceModel.asset;
//        ApexTransferModel *lastRecord = [self.historyManager getLastTransferHistoryOfAddress:self.fromAddressL.text];
//
//        if (lastRecord) {
//            historyModel.time = lastRecord.time;
//        }
//
//        [self.historyManager addTransferHistory:historyModel forWallet:self.fromAddressL.text];
//        [self.historyManager beginTimerToConfirmTransactionOfAddress:self.fromAddressL.text txModel:historyModel];
//        NSLog(@"eth txid %@",responseObject);
//
//        [self.navigationController popToRootViewControllerAnimated:YES];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self hideHUD];
//        [self showMessage:SOLocalizedStringFromTable(@"TransFailed", nil)];
//    }];
//}

//erc20 转账


//#pragma mark - neo transaction
//- (void)neoTransactionWithWallet:(NeomobileWallet*)wallet{
//    [self utxoSearch:wallet];
//}
//
//- (void)utxoSearch:(NeomobileWallet*)wallet{
//    NSString *address = _toAddressTF.text;
//    if (address.length <= 15) {
//        [self showMessage:SOLocalizedStringFromTable(@"SendMoneyAddress", nil)];
//        return;
//    }
//    
//    self.wallet = wallet;
//    if (!self.wallet) {
//        [self showMessage:SOLocalizedStringFromTable(@"OpenWalletFailed", nil)];
//        return;
//    }
//    
//    //创建neo/gas的tx 交易
//    if ([neo_assetid containsString:_balanceModel.asset] || [neoGas_Assetid containsString:_balanceModel.asset]) {
//        @weakify(self);
//        [self.viewModel getUtxoSuccess:^(CYLResponse *response) {
//            @strongify(self);
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
//            NSArray *unspendArr = dict[@"result"];
//            NSData *data = [NSJSONSerialization dataWithJSONObject:unspendArr options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *unspendStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            
//            NSError *err = nil;
//            NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:self.sendNumTF.text];
//            NeomobileTx *tx = [self.wallet createAssertTx:self.balanceModel.asset from:self.walletAddress to:self.toAddressTF.text amount:num.doubleValue unspent:unspendStr error:&err];
//            
//            if (err) {
//                [self showMessage:SOLocalizedStringFromTable(@"CreateTransFailed", nil)];
//            }else{
//                [self broadCastTransaction:tx];
//            }
//            
//        } fail:^(NSError *error) {
//            [self showMessage:SOLocalizedStringFromTable(@"UtxoFailed", nil)];
//        }];
//    }else{
//
//        NSError *err = nil;
//        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:self.sendNumTF.text];
//        num = [num decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@(pow(10, self.assetModel.precision.integerValue)).stringValue]];
//        NeomobileTx *nep5TX = [self.wallet createNep5Tx:_balanceModel.asset from:NeomobileDecodeAddress(self.wallet.address, nil) to:NeomobileDecodeAddress(self.toAddressTF.text, nil) amount:num.integerValue unspent:@"[]" error:&err];
//        if (err) {
//            [self showMessage:SOLocalizedStringFromTable(@"CreateTransFailed", nil)];
//        }else{
//            [self broadCastTransaction:nep5TX];
//        }
//    }
//}
//
//- (void)broadCastTransaction:(NeomobileTx*)tx{
//    [self showHUD];
//    [ApexWalletManager broadCastTransactionWithData:tx.data Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self hideHUD];
//        BOOL isSuccess = ((NSNumber*)responseObject).boolValue;
//        if (isSuccess) {
//            [self showMessage:SOLocalizedStringFromTable(@"TransSuccess", nil)];
//            
//            /**< 创建新的临时交易历史记录 */
//            ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
//            historyModel.txid = [tx.id_ hasPrefix:@"0x"] ? tx.id_ : [NSString stringWithFormat:@"0x%@",tx.id_];
//            historyModel.from = self.fromAddressL.text;
//            historyModel.to = self.toAddressTF.text;
//            historyModel.value = [NSString stringWithFormat:@"-%@",self.sendNumTF.text];
//            historyModel.status = ApexTransferStatus_Blocking;
//            historyModel.time = @"0";
//            historyModel.assetId = self.balanceModel.asset;
//            ApexTransferModel *lastRecord = [self.historyManager getLastTransferHistoryOfAddress:self.fromAddressL.text];
//            
//            if (lastRecord) {
//                historyModel.time = lastRecord.time;
//            }
//            
//            [self.historyManager addTransferHistory:historyModel forWallet:self.fromAddressL.text];
//            [self.historyManager beginTimerToConfirmTransactionOfAddress:self.fromAddressL.text txModel:historyModel];
//            NSLog(@"txid %@",tx.id_);
//            
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }else{
//            [self showMessage:SOLocalizedStringFromTable(@"TransFailed", nil)];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self hideHUD];
//        [self showMessage:SOLocalizedStringFromTable(@"TransFailed", nil)];
//    }];
//}
//
//-(NSString *)convertToJsonData:(NSDictionary *)dict{
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString;
//
//    if (!jsonData) {
//        
//        NSLog(@"%@",error);
//        
//    }else{
//        
//        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//        
//    }
//    
//    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
//    
//    NSRange range = {0,jsonString.length};
//    
//    //去掉字符串中的空格
//    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//    
//    NSRange range2 = {0,mutStr.length};
//    
//    //去掉字符串中的换行符
//    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
//    
//    return mutStr;
//}

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
    
    [[self.takeAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.sendNumTF.text = self.balanceModel.value;
    }];
}

- (IBAction)sliderValueChanged:(id)sender {
    self.gasPriceL.text = [NSString stringWithFormat:@"%.8lf ether", _gasSlider.value];
    self.viewModel.gasSliderValue = self.gasPriceL.text;
}


- (IBAction)sendAction:(id)sender {
    
    if (_sendNumTF.text.floatValue > _balanceModel.value.floatValue) {
        [self showMessage:SOLocalizedStringFromTable(@"BalanceNotEnough", nil)];
    }else if ([_toAddressTF.text isEqualToString:_walletAddress]){
        [self showMessage:SOLocalizedStringFromTable(@"InvalidateAddress", nil)];
    }else{
        //输入密码
        [ApexPassWordConfirmAlertView showEntryPasswordAlertAddress:_walletAddress walletManager:self.walletManager subTitle:@"" Success:^(id wallet) {
            
            self.viewModel.toAddress = self.toAddressTF.text;
            self.viewModel.amount = self.sendNumTF.text;
            
            if ([self.walletManager isKindOfClass:ETHWalletManager.class]) {
                [self.viewModel ethTransactionWithWallet:wallet];
            }else{
                [self.viewModel neoTransactionWithWallet:wallet];
            }
            
        } fail:^{
            [self showMessage:SOLocalizedStringFromTable(@"Password Error", nil)];
        }];
    }
}

#pragma mark - ------getter & setter------
- (void)setWalletManager:(id<ApexWalletManagerProtocal>)walletManager{
    _walletManager = walletManager;
    if ([walletManager isKindOfClass:ETHWalletManager.class]) {
        self.historyManager = [ETHTransferHistoryManager shareManager];
        _ethPanelView.hidden = NO;
    }else{
        self.historyManager = [ApexTransferHistoryManager shareManager];
        _ethPanelView.hidden = YES;
    }
    self.viewModel.historyManager = _historyManager;
}

- (ApexSendMoneyViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ApexSendMoneyViewModel alloc] init];
        _viewModel.address = self.walletAddress;
        _viewModel.ownerVC = self;
        _viewModel.balanceModel = self.balanceModel;
    }
    return _viewModel;
}

- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_scanBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
    }
    return _scanBtn;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = SOLocalizedStringFromTable(@"Transfer", nil);
    }
    return _titleLable;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 20, 30)];
        [_backBtn setImage:[UIImage imageNamed:@"back-4"] forState:UIControlStateNormal];
    }
    return _backBtn;
}
@end
