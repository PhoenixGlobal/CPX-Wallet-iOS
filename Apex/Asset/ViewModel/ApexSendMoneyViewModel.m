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
    [CYLNetWorkManager GET:@"utxos/" parameter:@{@"address":self.address} success:successBlock fail:failBlock];
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

- (void)broadEthTransactionWithNonce:(NSNumber*)nonce wallet:(EthmobileWallet*)wallet{
    [_ownerVC showHUD];
    [ETHWalletManager sendTxWithWallet:wallet to:self.toAddress nonce:nonce.stringValue amount:self.amount gas:_gasSliderValue success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_ownerVC hideHUD];
        /**< 创建新的临时交易历史记录 */
        ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
        historyModel.txid = [responseObject hasPrefix:@"0x"] ? responseObject : [NSString stringWithFormat:@"0x%@",responseObject];
        historyModel.from = _address;
        historyModel.to = _toAddress;
        historyModel.value = [NSString stringWithFormat:@"-%@",_amount];
        historyModel.status = ApexTransferStatus_Blocking;
        historyModel.time = @"0";
        historyModel.assetId = self.balanceModel.asset;
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


- (void)broadErc20TransactionWithNonce:(NSNumber*)nonce wallet:(EthmobileWallet*)wallet{
    [_ownerVC showHUD];
    ApexAssetModel *model = [self.balanceModel getRelativeETHAssetModel];
    [ETHWalletManager sendERC20TxWithWallet:wallet contractAddress:model.hex_hash to:_toAddress nonce:nonce.stringValue amount:_amount gas:_gasSliderValue assetModel:model success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_ownerVC hideHUD];
        /**< 创建新的临时交易历史记录 */
        ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
        historyModel.txid = [responseObject hasPrefix:@"0x"] ? responseObject : [NSString stringWithFormat:@"0x%@",responseObject];
        historyModel.from = _address;
        historyModel.to = _toAddress;
        historyModel.value = [NSString stringWithFormat:@"-%@",_amount];
        historyModel.status = ApexTransferStatus_Blocking;
        historyModel.time = @"0";
        historyModel.assetId = self.balanceModel.asset;
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
            NSArray *unspendArr = dict[@"result"];
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
            [_ownerVC showMessage:SOLocalizedStringFromTable(@"TransSuccess", nil)];
            
            /**< 创建新的临时交易历史记录 */
            ApexTransferModel *historyModel = [[ApexTransferModel alloc] init];
            historyModel.txid = [tx.id_ hasPrefix:@"0x"] ? tx.id_ : [NSString stringWithFormat:@"0x%@",tx.id_];
            historyModel.from = self.address;
            historyModel.to = self.toAddress;
            historyModel.value = [NSString stringWithFormat:@"-%@",self.amount];
            historyModel.status = ApexTransferStatus_Blocking;
            historyModel.time = @"0";
            historyModel.assetId = self.balanceModel.asset;
            ApexTransferModel *lastRecord = [self.historyManager getLastTransferHistoryOfAddress:self.address];
            
            if (lastRecord) {
                historyModel.time = lastRecord.time;
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

@end
