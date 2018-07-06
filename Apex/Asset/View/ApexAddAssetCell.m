//
//  ApexAddAssetCell.m
//  Apex
//
//  Created by chinapex on 2018/7/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexAddAssetCell.h"
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
        _typeL.text = [NSString stringWithFormat:@"%@ Token",model.symbol];
    }
    
    
}
@end
