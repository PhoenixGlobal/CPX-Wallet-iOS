//
//  ApexAddAssetCell.m
//  Apex
//
//  Created by chinapex on 2018/7/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexAddAssetCell.h"
#import <UIImageView+WebCache.h>
@interface ApexAddAssetCell()
@property (weak, nonatomic) IBOutlet UIImageView *IconIV;
@property (weak, nonatomic) IBOutlet UILabel *symbolL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@end

@implementation ApexAddAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
    [self bindView];
}

#pragma mark - ------private-----
- (void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.indicator.userInteractionEnabled = NO;
}

- (void)bindView{
//    [[RACObserve(self.indicator, selected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *x) {
//
//    }];
}

#pragma mark - ------setter-----
- (void)setModel:(ApexAssetModel *)model{
    _model = model;
    
    _symbolL.text = model.symbol;
    if ([model.hex_hash isEqualToString:assetId_Neo] || [model.hex_hash isEqualToString:assetId_NeoGas]) {
        _typeL.text = @"Asset";
    }else{
        _typeL.text = [NSString stringWithFormat:@"%@",model.name];
    }
    
    NSURL *url = [NSURL URLWithString:model.image_url];
    if (url) {
        if ([model.type isEqualToString:@"Erc20"]) {
            [_IconIV sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!image) {
                    _IconIV.image = ETHPlaceHolder;
                }
            }];
        }else {
            UIImage *image = [UIImage imageNamed:model.hex_hash inBundle:[ApexAssetModelManage resourceBundle] compatibleWithTraitCollection:nil];
            if (!image) {
                image = NEOPlaceHolder;
            }
            _IconIV.image = image;
        }
    }
}

@end
