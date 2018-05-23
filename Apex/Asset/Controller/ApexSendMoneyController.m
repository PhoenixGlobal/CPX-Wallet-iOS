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

@interface ApexSendMoneyController ()
@property (weak, nonatomic) IBOutlet UILabel *walletNameL;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressL;
@property (weak, nonatomic) IBOutlet UITextField *sendNumTF;
@property (weak, nonatomic) IBOutlet UITextField *toAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *txidTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordL;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;


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
    self.title = @"付款";
    self.walletNameL.text = self.walletName;
    self.fromAddressL.text = self.walletAddress;
    self.toAddressTF.text = self.toAddressIfHave;
    [ApexUIHelper addLineInView:self.sendNumTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    [ApexUIHelper addLineInView:self.txidTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    [ApexUIHelper addLineInView:self.passWordL color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    self.sendBtn.layer.cornerRadius = 6;
}

- (void)utxoSearch{
    if (_txidTF.text.length == 0 || _passWordL.text.length == 0 || _toAddressTF.text.length == 0) {
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
    
    NSString *txid = self.txidTF.text;
    if ([txid hasPrefix:@"0x"]) {
        txid = [txid substringFromIndex:2];
    }
    
    @weakify(self);
    [[ApexRPCClient shareRPCClient] invokeMethod:@"getrawtransaction" withParameters:@[txid,@1] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        self.txidModel = [ApexTXIDModel yy_modelWithDictionary:responseObject];
        [self blockIndexSearch:self.txidModel.blockhash];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMessage:[NSString stringWithFormat:@"获取utxo失败:%@",error]];
    }];
}

- (void)blockIndexSearch:(NSString*)blockHash{
    [[ApexRPCClient shareRPCClient] invokeMethod:@"getblock" withParameters:@[blockHash,@1] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.confirmBlock = responseObject[@"index"];
        [self creatUTXO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMessage:[NSString stringWithFormat:@"获取blockIndex失败:%@",error]];
    }];
}

- (void)creatUTXO{
    
    VoutObject *theVout = nil;
    for (VoutObject *vout in self.txidModel.vout) {
        if (vout.value.doubleValue >= self.sendNumTF.text.doubleValue && [vout.address isEqualToString:self.fromAddressL.text]) {
            theVout = vout;
        }
    }
    
    if (!theVout) {
        [self showMessage:@"vout获取失败,或者您没有足够余额"];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd/HH:mm:ss,"];
    NSString *createTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.txidModel.blocktime.integerValue]];
    createTime = [createTime stringByReplacingOccurrencesOfString:@"/" withString:@"T"];
    createTime = [createTime stringByReplacingOccurrencesOfString:@"," withString:@"Z"];

    NSError *err = nil;
    NSString *unspend = [NSString stringWithFormat:@"[{\"txid\":\"%@\",\"block\": %@,\"vout\": {\"Address\": \"%@\",\"Asset\": \"%@\",\"Value\": \"%@\",\"N\": %@},\"spentBlock\": -1,\"spentTime\": \"\",\"createTime\": \"%@\",\"gas\": \"\"}]",self.txidModel.txid,self.confirmBlock.stringValue,theVout.address,theVout.asset,theVout.value,theVout.n,createTime];
    NSLog(@"%@",unspend);
    NeomobileTx *tx = [self.wallet createAssertTx:theVout.asset from:_wallet.address to:self.toAddressTF.text amount:_sendNumTF.text.doubleValue unspent:unspend error:&err];
    if (err) {
        [self showMessage:@"tx生成失败"];
    }else{
        [self broadCastTransaction:tx];
    }
}

- (void)broadCastTransaction:(NeomobileTx*)tx{
    [[ApexRPCClient shareRPCClient] invokeMethod:@"sendrawtransaction" withParameters:@[tx.data] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL isSuccess = ((NSNumber*)responseObject).boolValue;
        if (isSuccess) {
            [self showMessage:@"广播交易成功"];
            ApexTXRecorderModel *txRecordModel = [[ApexTXRecorderModel alloc] init];
            txRecordModel.txid = tx.id_;
            txRecordModel.fromAddress = self.fromAddressL.text;
            txRecordModel.toAddress = self.toAddressTF.text;
            txRecordModel.value = self.sendNumTF.text;
            txRecordModel.data = tx.data;
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

@end
