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

@property (nonatomic, strong) ApexAssetModel *assetModel;
@end

@implementation ApexSendMoneyController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self handleEvent];
    
    [self setNav];
}

- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController lt_setBackgroundColor:[UIColor colorWithRed255:70 green255:105 blue255:214 alpha:1]];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
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
    self.unitL.text = self.unit;
    self.walletNameL.text = self.walletName;
    self.fromAddressL.text = self.walletAddress;
    self.toAddressTF.text = self.toAddressIfHave;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanBtn];
    
    [ApexUIHelper addLineInView:self.sendNumTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    self.sendBtn.layer.cornerRadius = 6;
    
    for (ApexAssetModel *model in [ApexAssetModelManage getLocalAssetModelsArr]) {
        if ([model.hex_hash containsString:self.balanceModel.asset]) {
            self.assetModel = model;
            break;
        }
    }
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
    
    //创建neo/gas的tx 交易
    if ([neo_assetid containsString:_balanceModel.asset] || [neoGas_Assetid containsString:_balanceModel.asset]) {
        @weakify(self);
        [self.viewModel getUtxoSuccess:^(CYLResponse *response) {
            @strongify(self);
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
            NSArray *unspendArr = dict[@"result"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:unspendArr options:NSJSONWritingPrettyPrinted error:nil];
            NSString *unspendStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSError *err = nil;
            NeomobileTx *tx = [self.wallet createAssertTx:self.balanceModel.asset from:self.walletAddress to:self.toAddressTF.text amount:self.sendNumTF.text.floatValue unspent:unspendStr error:&err];
            if (err) {
                [self showMessage:@"交易生成失败"];
            }else{
                [self broadCastTransaction:tx];
            }
            
        } fail:^(NSError *error) {
            [self showMessage:@"utxo获取失败"];
        }];
    }else{
        
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        dic[@"txid"] = @"0x744241ccd9a85e2732c14d121c00022c832a9edfdefc9cae43c41b49f9aa48db";
//        dic[@"block"] = @(2274806);
//        dic[@"vout"] = @{@"Address":self.walletAddress,@"Asset":self.balanceModel.asset,@"Value":@"1000000",@"N":@(0)};
//        dic[@"spentBlock"] = @(-1);
//        dic[@"spentTime"] = @"";
//        dic[@"createTime"] = @"2018-05-16T10:40:47Z";
//        dic[@"gas"] = @"";
//        NSString *unspend = [NSString stringWithFormat:@"[%@]",[self convertToJsonData:dic]];
//
        NSError *err = nil;
        NeomobileTx *nep5TX = [self.wallet createNep5Tx:_balanceModel.asset from:NeomobileDecodeAddress(self.wallet.address, nil) to:NeomobileDecodeAddress(self.toAddressTF.text, nil) amount:self.sendNumTF.text.floatValue*pow(10, self.assetModel.precision.integerValue) unspent:@"[]" error:&err];
        if (err) {
            [self showMessage:@"交易生成失败"];
        }else{
            [self broadCastTransaction:nep5TX];
        }
    }
}

- (void)broadCastTransaction:(NeomobileTx*)tx{
    [ApexWalletManager broadCastTransactionWithData:tx.data Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL isSuccess = ((NSNumber*)responseObject).boolValue;
        if (isSuccess) {
            [self showMessage:@"广播交易成功"];
            
            /**< 创建新的临时交易历史记录 */
            ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
            historyModel.txid = [tx.id_ hasPrefix:@"0x"] ? tx.id_ : [NSString stringWithFormat:@"0x%@",tx.id_];
            historyModel.from = self.fromAddressL.text;
            historyModel.to = self.toAddressTF.text;
            historyModel.value = [NSString stringWithFormat:@"-%@",self.sendNumTF.text];
            historyModel.status = ApexTransferStatus_Blocking;
            historyModel.time = @((NSInteger)[[NSDate date] timeIntervalSince1970]).stringValue;
            [[ApexTransferHistoryManager shareManager] addTransferHistory:historyModel forWallet:self.fromAddressL.text];
            [[ApexTransferHistoryManager shareManager] beginTimerToConfirmTransactionOfAddress:self.fromAddressL.text txModel:historyModel];
            NSLog(@"txid %@",tx.id_);
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self showMessage:@"广播交易失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMessage:@"广播交易失败,请检查网络连接"];
    }];
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

//- (void)saveTX:(ApexTXRecorderModel*)model{
//    NSMutableArray *arr = [TKFileManager loadDataWithFileName:TXRECORD_KEY];
//    if (arr == nil) {
//        arr = [NSMutableArray array];
//    }
//
//    [arr addObject:model];
//
//    [TKFileManager saveData:arr withFileName:TXRECORD_KEY];
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
}

- (IBAction)sendAction:(id)sender {
    if (_sendNumTF.text.floatValue > _balanceModel.value.floatValue) {
        [self showMessage:@"金额不足"];
    }else{
        [ApexPassWordConfirmAlertView showEntryPasswordAlertAddress:_walletAddress subTitle:@"" Success:^(NeomobileWallet *wallet) {
            [self utxoSearch:wallet];
        } fail:^{
            [self showMessage:@"密码输入错误"];
        }];
    }
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
        [_scanBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
    }
    return _scanBtn;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.text = @"转账";
    }
    return _titleLable;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back-4"] forState:UIControlStateNormal];
    }
    return _backBtn;
}
@end
