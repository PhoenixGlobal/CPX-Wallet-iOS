//
//  ApexWalletCell.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWalletCell.h"

@interface ApexWalletCell()
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, strong) ApexAccountStateModel *accountModel;
@end

@implementation ApexWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5;
}

- (void)setWalletNameStr:(NSString *)walletNameStr{
    _walletNameStr = walletNameStr;
    self.walletName.text = walletNameStr;
}

- (void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    self.address.text = addressStr;
    [self requestBalance];
}

- (void)requestBalance{
    @weakify(self);
    [[self topViewController] showHUD];
    [[ApexRPCClient shareRPCClient] invokeMethod:@"getaccountstate" withParameters:@[self.addressStr] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        [[self topViewController] hideHUD];
        self.accountModel = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
        self.accountModel.balances.count == 0 ? (self.balance.text = @"0") : (self.balance.text = self.accountModel.balances.firstObject.value);
        if (self.didFinishRequestBalanceSub) {
            [self.didFinishRequestBalanceSub sendNext:self.accountModel];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.balance.text = @"N/A";
    }];
}

- (ApexAccountStateModel *)getAccountInfo{
    return _accountModel;
}

@end
