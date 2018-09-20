//
//  ApexWallerItemCell.m
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWallerItemCell.h"
@interface ApexWallerItemCell()

@property (nonatomic, strong) UIImageView *iconIMageV;
@property (nonatomic, strong) UILabel *walletNameL;
@property (nonatomic, strong) UILabel *walletAddL;

@property (nonatomic, strong) ApexAccountStateModel *accountModel;

@end

@implementation ApexWallerItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.layer.cornerRadius = 6;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrows-1_minimal-left"]];
        
        [self.contentView addSubview:self.iconIMageV];
        [self.contentView addSubview:self.walletNameL];
        [self.contentView addSubview:self.walletAddL];
        [self.contentView addSubview:self.backupTipBtn];
        
        [self.iconIMageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15.0f);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        }];
        
        [self.walletNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(70.0f);
            make.top.equalTo(self.contentView).with.offset(20.0f);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(23.0f);
        }];
        
        [self.walletAddL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.walletNameL);
            make.top.equalTo(self.walletNameL.mas_bottom).with.offset(10.0f);
            make.height.mas_equalTo(16.0f);
        }];
        
        CGFloat backupWidth = [ApexUIHelper calculateTextLength:[UIFont systemFontOfSize:10] givenText:SOLocalizedStringFromTable(@"Back up", nil)];
        
        [self.backupTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.centerY.equalTo(self.walletNameL);
            make.size.mas_equalTo(CGSizeMake(backupWidth, 18.0f));
        }];
    }
    
    return self;
}

- (UIImageView *)iconIMageV
{
    if (!_iconIMageV) {
        _iconIMageV = [[UIImageView alloc] init];
        _iconIMageV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIMageV.clipsToBounds = YES;
    }
    
    return _iconIMageV;
}

- (UILabel *)walletNameL
{
    if (!_walletNameL) {
        _walletNameL = [[UILabel alloc] init];
        _walletNameL.font = [UIFont systemFontOfSize:19];
        _walletNameL.textColor = [UIColor blackColor];
    }
    
    return _walletNameL;
}

- (UILabel *)walletAddL
{
    if (!_walletAddL) {
        _walletAddL = [[UILabel alloc] init];
        _walletAddL.font = [UIFont systemFontOfSize:13];
        _walletAddL.textColor = [UIColor blackColor];
        _walletAddL.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    return _walletAddL;
}

- (UIButton *)backupTipBtn
{
    if (!_backupTipBtn) {
        _backupTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backupTipBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_backupTipBtn setTitleColor:[UIColor colorWithHexString:@"B3D38D"] forState:UIControlStateNormal];
        _backupTipBtn.layer.borderColor = [UIColor colorWithHexString:@"B3D38D"].CGColor;
        _backupTipBtn.layer.borderWidth = 1.0/kScale;
        _backupTipBtn.layer.cornerRadius = 9;
        [_backupTipBtn setTitle:SOLocalizedStringFromTable(@"Back up", nil) forState:UIControlStateNormal];
    }
    
    return _backupTipBtn;
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
    self.backupTipBtn.hidden = model.isBackUp;
}

- (ApexAccountStateModel *)getAccountInfo{
    return _accountModel;
}

@end
