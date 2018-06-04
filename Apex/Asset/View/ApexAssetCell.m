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
@property (weak, nonatomic) IBOutlet UILabel *assetNameLThree;
@property (weak, nonatomic) IBOutlet UILabel *percentL;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *balanceL;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end

@implementation ApexAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    [CYLEmptyView showEmptyViewOnView:self.baseView emptyType:CYLEmptyViewType_EmptyData message:@"暂无数据" refreshBlock:nil];
}

- (void)setModel:(BalanceObject *)model{
    _model = model;
    _balanceL.text = model.value;
}
@end
