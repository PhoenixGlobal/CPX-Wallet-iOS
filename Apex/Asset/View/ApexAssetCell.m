//
//  ApexAssetCell.m
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexAssetCell.h"
#import "CYLEmptyView.h"

@interface ApexAssetCell()
@property (weak, nonatomic) IBOutlet UILabel *assetNameL;
@property (weak, nonatomic) IBOutlet UILabel *assetNameLTwo;
@property (weak, nonatomic) IBOutlet UILabel *balanceL;
@property (weak, nonatomic) IBOutlet UIButton *mappignBtn;

@end

@implementation ApexAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
//    self.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 1);
//    self.layer.shadowOpacity = 0.8;
//    self.layer.shadowRadius = 3;
    
    [_mappignBtn setTitleColor:[ApexUIHelper grayColor] forState:UIControlStateNormal];
    _mappignBtn.layer.borderColor = [ApexUIHelper grayColor].CGColor;
    _mappignBtn.layer.borderWidth = 1.0/kScale;
    _mappignBtn.layer.cornerRadius = 4;
    _mappignBtn.hidden = YES;
}

- (void)setModel:(BalanceObject *)model{
    _model = model;
    _balanceL.text = model.value;
    
    NSString *assetName = @"err";
    if ([model.asset isEqualToString:assetId_CPX]) {
        assetName = @"CPX";
        _mappignBtn.hidden = NO;
    }else if ([model.asset isEqualToString:assetId_Neo]){
        assetName = @"NEO";
    }else if ([model.asset isEqualToString:assetId_NeoGas]){
        assetName = @"GAS";
    }
    _assetNameL.text = assetName;
    _assetNameLTwo.text = assetName;
}
@end
