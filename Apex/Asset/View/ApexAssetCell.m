//
//  ApexAssetCell.m
//  Apex
//
//  Created by chinapex on 2018/6/4.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexAssetCell.h"
#import "CYLEmptyView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ApexAssetCell()
@property (weak, nonatomic) IBOutlet UILabel *assetNameL;
@property (weak, nonatomic) IBOutlet UILabel *assetNameLTwo;
@property (weak, nonatomic) IBOutlet UILabel *balanceL;
@property (weak, nonatomic) IBOutlet UIButton *mappignBtn;
@property (weak, nonatomic) IBOutlet UIImageView *assetIcon;

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
    _mappignBtn.backgroundColor = [ApexUIHelper grayColor240];
    
    
//    _assetIcon.image = NEOPlaceHolder;
}

- (void)setModel:(BalanceObject *)model{
    _model = model;
    _balanceL.text = model.value.floatValue == 0 ? @"0.0" : model.value;
    
    for (ApexAssetModel *assetModel in [ApexAssetModelManage getLocalAssetModelsArr]) {
        if ([assetModel.hex_hash containsString:model.asset]) {
            
            _assetNameL.text = assetModel.symbol;
            _assetNameLTwo.text = @"";
            
            if ([assetModel.hex_hash containsString:assetId_CPX]) {
                _mappignBtn.hidden = NO;
                self.assetIcon.image = CPX_Logo;
            }else{
                _mappignBtn.hidden = YES;
                self.assetIcon.image = NEOPlaceHolder;
            }
            
//            NSURL *url = [NSURL URLWithString:assetModel.image_url];
//            if (url) {
//                [self.assetIcon sd_setImageWithURL:url];
//            }
            break;
        }
    }
}
@end
