//
//  ApexSendMoneyViewModel.m
//  Apex
//
//  Created by chinapex on 2018/5/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSendMoneyViewModel.h"
#import <AFHTTPSessionManager.h>
#import "ApexTransferModel.h"

@interface ApexSendMoneyViewModel()

@end

@implementation ApexSendMoneyViewModel
- (void)getUtxoSuccess:(void (^)(CYLResponse *response))successBlock fail:(void (^)(NSError *error))failBlock{
    [CYLNetWorkManager GET:@"utxos" parameter:@{@"address":self.address} success:successBlock fail:failBlock];
}

#pragma mark - eth 转账
- (void)ethTransactionWithWallet:(EthmobileWallet *)wallet{
    if ([_balanceModel.asset isEqualToString:assetId_Eth]) {
        //eth转账
        [ETHWalletManager requestTransactionCount:self.address success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self broadEthTransactionWithNonce:responseObject wallet:wallet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_ownerVC showMessage:SOLocalizedStringFromTable(@"gainNonceFail", nil)];
        }];
    }else{
        //erc20转账
        [ETHWalletManager requestTransactionCount:self.address success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self broadErc20TransactionWithNonce:responseObject wallet:wallet];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_ownerVC showMessage:SOLocalizedStringFromTable(@"gainNonceFail", nil)];
        }];
    }
}

- (void)broadEthTransactionWithNonce:(NSString*)nonce wallet:(EthmobileWallet*)wallet{
    [_ownerVC showHUD];
    [ETHWalletManager sendTxWithWallet:wallet to:self.toAddress nonce:nonce amount:self.amount gas:_gasSliderValue success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_ownerVC hideHUD];
        [_ownerVC showMessageOnWindow:SOLocalizedStringFromTable(@"TransSuccess", nil)];
        /**< 创建新的临时交易历史记录 */
        ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
        historyModel.txid = [responseObject hasPrefix:@"0x"] ? responseObject : [NSString stringWithFormat:@"0x%@",responseObject];
        historyModel.from = _address;
        historyModel.to = _toAddress;
        historyModel.value = [NSString stringWithFormat:@"-%@",_amount];
        historyModel.status = ApexTransferStatus_Blocking;
        historyModel.time = @"0";
        historyModel.assetId = self.balanceModel.asset;
        historyModel.type = EthType;
        historyModel.nonce = nonce;
        ApexTransferModel *lastRecord = [self.historyManager getLastTransferHistoryOfAddress:self.address];
        
        if (lastRecord) {
            historyModel.time = lastRecord.time;
        }
        
        [self.historyManager addTransferHistory:historyModel forWallet:self.address];
        [self.historyManager beginTimerToConfirmTransactionOfAddress:self.address txModel:historyModel];
        NSLog(@"eth txid %@",responseObject);
        
        [_ownerVC.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_ownerVC hideHUD];
        [_ownerVC showMessage:SOLocalizedStringFromTable(@"TransFailed", nil)];
    }];
}


- (void)broadErc20TransactionWithNonce:(NSString*)nonce wallet:(EthmobileWallet*)wallet{
    [_ownerVC showHUD];
    ApexAssetModel *model = [self.balanceModel getRelativeETHAssetModel];
    [ETHWalletManager sendERC20TxWithWallet:wallet contractAddress:model.hex_hash to:_toAddress nonce:nonce amount:_amount gas:_gasSliderValue assetModel:model success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_ownerVC hideHUD];
        [_ownerVC showMessageOnWindow:SOLocalizedStringFromTable(@"TransSuccess", nil)];
        /**< 创建新的临时交易历史记录 */
        ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
        historyModel.txid = [responseObject hasPrefix:@"0x"] ? responseObject : [NSString stringWithFormat:@"0x%@",responseObject];
        historyModel.from = _address;
        historyModel.to = _toAddress;
        historyModel.value = [NSString stringWithFormat:@"-%@",_amount];
        historyModel.status = ApexTransferStatus_Blocking;
        historyModel.time = @"0";
        historyModel.symbol = model.symbol;
        historyModel.decimal = model.precision;
        historyModel.assetId = self.balanceModel.asset;
        historyModel.type = Erc20Type;
        historyModel.nonce = nonce;
        ApexTransferModel *lastRecord = [self.historyManager getLastTransferHistoryOfAddress:self.address];
        
        if (lastRecord) {
            historyModel.time = lastRecord.time;
        }
        
        [self.historyManager addTransferHistory:historyModel forWallet:self.address];
        [self.historyManager beginTimerToConfirmTransactionOfAddress:self.address txModel:historyModel];
        NSLog(@"eth txid %@",responseObject);
        
        [_ownerVC.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_ownerVC hideHUD];
        [_ownerVC showMessage:SOLocalizedStringFromTable(@"TransFailed", nil)];
    }];
}

//neo 转账
#pragma mark - neo transaction
- (void)neoTransactionWithWallet:(NeomobileWallet*)wallet{
    [self utxoSearch:wallet];
}

- (void)utxoSearch:(NeomobileWallet*)wallet{
    NSString *address = _toAddress;
    if (address.length <= 15) {
        [_ownerVC showMessage:SOLocalizedStringFromTable(@"SendMoneyAddress", nil)];
        return;
    }
    
    if (!wallet) {
        [_ownerVC showMessage:SOLocalizedStringFromTable(@"OpenWalletFailed", nil)];
        return;
    }
    
    //创建neo/gas的tx 交易
    if ([neo_assetid containsString:_balanceModel.asset] || [neoGas_Assetid containsString:_balanceModel.asset]) {
        @weakify(self);
        [self getUtxoSuccess:^(CYLResponse *response) {
            @strongify(self);
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
            NSArray *unspendArr = dict[@"data"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:unspendArr options:NSJSONWritingPrettyPrinted error:nil];
            NSString *unspendStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSError *err = nil;
            NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:_amount];
            NeomobileTx *tx = [wallet createAssertTx:self.balanceModel.asset from:_address to:_toAddress amount:num.doubleValue unspent:unspendStr error:&err];
            
            if (err) {
                [_ownerVC showMessage:SOLocalizedStringFromTable(@"CreateTransFailed", nil)];
            }else{
                [self broadCastTransaction:tx];
            }
            
        } fail:^(NSError *error) {
            [_ownerVC showMessage:SOLocalizedStringFromTable(@"UtxoFailed", nil)];
        }];
    }else{
        
        NSError *err = nil;
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:_amount];
        ApexAssetModel *asset = [_balanceModel getRelativeNeoAssetModel];
        num = [num decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@(pow(10, asset.precision.integerValue)).stringValue]];
        NeomobileTx *nep5TX = [wallet createNep5Tx:_balanceModel.asset from:NeomobileDecodeAddress(wallet.address, nil) to:NeomobileDecodeAddress(self.toAddress, nil) amount:num.integerValue unspent:@"[]" error:&err];
        if (err) {
            [_ownerVC showMessage:SOLocalizedStringFromTable(@"CreateTransFailed", nil)];
        }else{
            [self broadCastTransaction:nep5TX];
        }
    }
}

- (void)broadCastTransaction:(NeomobileTx*)tx{
    [_ownerVC showHUD];
    [ApexWalletManager broadCastTransactionWithData:tx.data Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_ownerVC hideHUD];
        BOOL isSuccess = ((NSNumber*)responseObject).boolValue;
        if (isSuccess) {
            
            [_ownerVC showMessageOnWindow:SOLocalizedStringFromTable(@"TransSuccess", nil)];
            ApexAssetModel *model = [_balanceModel getRelativeNeoAssetModel];
            /**< 创建新的临时交易历史记录 */
            ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
            historyModel.txid = [tx.id_ hasPrefix:@"0x"] ? tx.id_ : [NSString stringWithFormat:@"0x%@",tx.id_];
            historyModel.from = self.address;
            historyModel.to = self.toAddress;
            historyModel.value = [NSString stringWithFormat:@"-%@",self.amount];
            historyModel.status = ApexTransferStatus_Blocking;
            historyModel.time = @"0";
            historyModel.assetId = self.balanceModel.asset;
            historyModel.type = NeoType;
            historyModel.symbol = model.symbol;
            historyModel.decimal = model.precision;
            ApexTransferModel *lastRecord = [self.historyManager getLastTransferHistoryOfAddress:self.address];
            
            if (lastRecord) {
                double lastTime = lastRecord.time.doubleValue;
                lastTime += 1;
                historyModel.time = @(lastTime).stringValue;
            }
            
            [self.historyManager addTransferHistory:historyModel forWallet:self.address];
            [self.historyManager beginTimerToConfirmTransactionOfAddress:self.address txModel:historyModel];
            NSLog(@"txid %@",tx.id_);
            
            [_ownerVC.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [_ownerVC showMessage:SOLocalizedStringFromTable(@"TransFailed", nil)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_ownerVC hideHUD];
        [_ownerVC showMessage:SOLocalizedStringFromTable(@"TransFailed", nil)];
    }];
}

- (void)updateEthValue{
    [ETHWalletManager requestETHBalanceOfAddress:_address success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.currentEthNumber = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.currentEthNumber = @"0";
    }];
}


- (void)getCurrentGasPrice:(void (^)(NSString *))successBlock fail:(void (^)(NSError *))failBlock{
    //{"jsonrpc":"2.0","method":"eth_gasPrice","params":[],"id":73}
    [ETHWalletManager getCurrentGasPrice:successBlock fail:failBlock];
}
@end
