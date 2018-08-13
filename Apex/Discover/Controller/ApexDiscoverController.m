//
//  ApexDiscoverController.m
//  Apex
//
//  Created by chinapex on 2018/5/18.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexDiscoverController.h"
#import "ApexImportWalletController.h"
#import "ApexETHTransactionModel.h"

@interface ApexDiscoverController ()
@property (nonatomic, strong) EthmobileWallet *wallet; /**<  */
@end

@implementation ApexDiscoverController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[ApexUIHelper navColor]];
}

- (void)viewWillDisappear:(BOOL)animated{

}

#pragma mark - ------private------
- (void)setUI{
    self.title = @"发现";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    NSError *err = nil;
    _wallet = EthmobileFromKeyStore(@"{\"address\":\"77ebad3064c5ff81bc63632ea10a8a0ba4382cf5\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"badadb3b1da48ac7bfdbcd9ae1f59fca74365373584785342cb5ef5f8d1a91b8\",\"cipherparams\":{\"iv\":\"db647a8a94d80ec1187fba12b90f51d1\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"304cf039af5228e4a78cdb677da77355518031ae6a92669c3663802ce50046dc\"},\"mac\":\"8f19589be75bfa985e5663b812384de19c820e484651cdba7ed5df64ee1d5262\"},\"id\":\"5d579104-555b-4a31-8077-37a923243c4a\",\"version\":3}", @"123456", &err);
    if (err) {
        NSLog(@"%@",err);
    }
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [ETHWalletManager sendTxWithWallet:_wallet to:@"0xbe1973821307e4f6b20b03696d036e4c3c2cdd65" nonce:@"4" amount:@"0.5" gas:@"0.02" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
           
            [ETHWalletManager requestTransactionReceiptByHash:responseObject success:^(AFHTTPRequestOperation *operation, ApexETHReceiptModel *responseObject) {
                NSLog(@"%@",responseObject.status);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - ------getter & setter------

@end
