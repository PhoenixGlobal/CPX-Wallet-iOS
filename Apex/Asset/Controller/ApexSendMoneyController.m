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

@interface ApexSendMoneyController ()
@property (weak, nonatomic) IBOutlet UILabel *walletNameL;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressL;
@property (weak, nonatomic) IBOutlet UITextField *sendNumTF;
@property (weak, nonatomic) IBOutlet UITextField *toAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordL;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

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
    self.walletNameL.text = self.walletName;
    self.fromAddressL.text = self.walletAddress;
    self.toAddressTF.text = self.toAddressIfHave;
    [ApexUIHelper addLineInView:self.sendNumTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    [ApexUIHelper addLineInView:self.passWordL color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    self.sendBtn.layer.cornerRadius = 6;
}

- (void)utxoSearch{
    if (_passWordL.text.length == 0 || _toAddressTF.text.length == 0) {
        [self showMessage:@"请填写完整信息"];
        return;
    }
    
    NSError *err = nil;
    NSString *keys = [PDKeyChain load:KEYCHAIN_KEY(self.fromAddressL.text)];
    self.wallet = NeomobileFromKeyStore(keys, _passWordL.text, &err);
    if (err) {
        [self showMessage:@"密码错误,钱包开启失败"];
        return;
    }
    
    @weakify(self);
    [self.viewModel getUtxoSuccess:^(CYLResponse *response) {
        @strongify(self);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSArray *unspendArr = dict[@"result"];
//        unspendArr = [self prepareUnspend:unspendArr];
        NSData *data = [NSJSONSerialization dataWithJSONObject:unspendArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *unspendStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError *err = nil;
        NeomobileTx *tx = [self.wallet createAssertTx:neo_assetid from:self.wallet.address to:self.toAddressTF.text amount:self.sendNumTF.text.doubleValue unspent:unspendStr error:&err];
        if (err) {
            [self showMessage:@"tx生成失败"];
        }else{
            [self broadCastTransaction:tx];
        }
        
    } fail:^(NSError *error) {
        [self showMessage:@"tx获取失败"];
    }];
}

//- (NSArray*)prepareUnspend:(NSArray*)unspendArr{
//    NSMutableArray *tempArr = [NSMutableArray array];
//    for (NSDictionary *dic in unspendArr) {
//        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        muDic[@"spentBlock"] = @(-1);
//        muDic[@"spentTime"] = @"";
//        NSNumber *creatTime = muDic[@"createTime"];
//        muDic[@"createTime"] = @"2018-05-30T14:02:39Z";
//        [tempArr addObject:muDic];
//    }
//    return tempArr;
//}

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
        [self showMessage:@"广播交易失败"];
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

#pragma mark - ------eventResponse------

- (IBAction)sendAction:(id)sender {
    [self utxoSearch];
}
#pragma mark - ------getter & setter------
- (ApexSendMoneyViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ApexSendMoneyViewModel alloc] init];
        _viewModel.address = self.walletAddress;
    }
    return _viewModel;
}
@end
