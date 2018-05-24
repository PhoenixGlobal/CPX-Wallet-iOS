//
//  ApexWallerItemCell.m
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWallerItemCell.h"
@interface ApexWallerItemCell()
@property (weak, nonatomic) IBOutlet UILabel *walletNameL;
@property (weak, nonatomic) IBOutlet UILabel *walletAddL;
@property (weak, nonatomic) IBOutlet UILabel *valueL;
@property (nonatomic, strong) ApexAccountStateModel *accountModel;
@end

@implementation ApexWallerItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 6;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setWalletNameStr:(NSString *)walletNameStr{
    _walletNameStr = walletNameStr;
    self.walletNameL.text = walletNameStr;
}

- (void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    self.walletAddL.text = addressStr;
    self.valueL.text = @"N/A";
    [self requestBalance];
}

- (void)requestBalance{
    @weakify(self);
    [[ApexRPCClient shareRPCClient] invokeMethod:@"getaccountstate" withParameters:@[self.addressStr] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(self);
        self.accountModel = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
        //延时加载
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.accountModel.balances.count == 0 ? (self.valueL.text = @"0") : (self.valueL.text = self.accountModel.balances.firstObject.value);
        });
        if (self.didFinishRequestBalanceSub) {
            [self.didFinishRequestBalanceSub sendNext:self.accountModel];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.valueL.text = @"N/A";
    }];
}

- (ApexAccountStateModel *)getAccountInfo{
    return _accountModel;
}
@end
