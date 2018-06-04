//
//  ApexAssetMainViewCell.m
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexAssetMainViewCell.h"

@interface ApexAssetMainViewCell()
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, assign) CGPoint startP;
@property (nonatomic, assign) CGPoint startTouchP;

@property (nonatomic, strong) ApexAccountStateModel *accountModel;
@property (nonatomic, assign) CGAffineTransform originTransForm;
@property (nonatomic, assign) CGFloat opDelta; /**< 位移值 */
@property (nonatomic, assign) CGPoint initialVelocity;
@end

@implementation ApexAssetMainViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUI];
}

- (void)setUI{
    self.startP = CGPointMake(kScreenW, 0);
    self.backgroundColor = [ApexUIHelper grayColor240];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)setWalletNameStr:(NSString *)walletNameStr{
    _walletNameStr = walletNameStr;
    self.walletName.text = walletNameStr;
}

- (void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    self.address.text = addressStr;
}

//- (void)requestBalance{
//    @weakify(self);
//    [ApexWalletManager getAccountStateWithAddress:self.addressStr Success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        @strongify(self);
//        self.accountModel = [ApexAccountStateModel yy_modelWithDictionary:responseObject];
//        //延时加载 避免一闪而过影响体验
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.accountModel.balances.count == 0 ? (self.balance.text = @"0") : (self.balance.text = self.accountModel.balances.firstObject.value);
//        });
//        if (self.didFinishRequestBalanceSub) {
//            [self.didFinishRequestBalanceSub sendNext:self.accountModel];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        self.balance.text = @"N/A";
//    }];
//}

//- (ApexAccountStateModel *)getAccountInfo{
//    return _accountModel;
//}

@end
