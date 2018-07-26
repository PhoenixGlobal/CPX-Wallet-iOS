//
//  ApexChangeWalletCell.m
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexChangeWalletCell.h"
#import "ApexWalletModel.h"
@interface ApexChangeWalletCell()
@property (weak, nonatomic) IBOutlet UILabel *walletNameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIImageView *indicator;

@end

@implementation ApexChangeWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addLinecolor:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
}

- (void)setModel:(ApexWalletModel *)model{
    _model = model;
    _walletNameL.text = model.name;
    _addressL.text = model.address;
    
    NSString *bindAddress = [TKFileManager ValueWithKey:KBindingWalletAddress];
    if ([bindAddress isEqualToString:model.address]) {
        self.indicator.hidden = NO;
    }else{
        self.indicator.hidden = YES;
    }
}

@end
