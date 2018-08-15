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
@property (weak, nonatomic) IBOutlet UIImageView *iconIMageV;

@property (nonatomic, strong) ApexAccountStateModel *accountModel;
@end

@implementation ApexWallerItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 6;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.backupTipBtn setTitleColor:[UIColor colorWithHexString:@"B3D38D"] forState:UIControlStateNormal];
    self.backupTipBtn.layer.borderColor = [UIColor colorWithHexString:@"B3D38D"].CGColor;
    self.backupTipBtn.layer.borderWidth = 1.0/kScale;
    self.backupTipBtn.layer.cornerRadius = 9;
    [self.backupTipBtn setTitle:SOLocalizedStringFromTable(@"Back up", nil) forState:UIControlStateNormal];
    [self.backupTipBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)setModel:(ApexWalletModel *)model
{
    _model = model;
    
    if([model isKindOfClass:ETHWalletModel.class]){
        _iconIMageV.image = ETHPlaceHolder;
    }else if ([model isKindOfClass:ApexWalletModel.class]) {
        _iconIMageV.image = NEOPlaceHolder;
    }
    
    self.walletNameL.text = model.name;
    self.walletAddL.text = model.address;
    self.valueL.text = @"N/A";
    self.backupTipBtn.hidden = model.isBackUp;
}

- (ApexAccountStateModel *)getAccountInfo{
    return _accountModel;
}
@end
