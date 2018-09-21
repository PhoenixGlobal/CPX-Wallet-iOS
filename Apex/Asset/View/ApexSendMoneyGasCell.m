//
//  ApexSendMoneyGasCell.m
//  Apex
//
//  Created by lichao on 2018/9/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSendMoneyGasCell.h"

@implementation ApexSendMoneyGasCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.currentGasSinglePriceL];
        [self.contentView addSubview:self.gasSlider];
        
        [self.contentView addSubview:self.slowL];
        [self.contentView addSubview:self.fastL];
        [self.contentView addSubview:self.currentGasPriceL];
        
//        [self.contentView addSubview:self.TotalEthTitle];
        [self.contentView addSubview:self.totalETHL];
        
        [self.currentGasSinglePriceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(15.0f);
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.size.mas_equalTo(CGSizeMake(kScreenW - 25.0f, 15.0f));
        }];
        
        [self.gasSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.currentGasSinglePriceL.mas_bottom).with.offset(10.0f);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(kScreenW - 90.0f, 30.0f));
        }];

        [self.slowL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gasSlider).with.offset(-30.0f);
            make.top.equalTo(self.gasSlider.mas_bottom).with.offset(10.0f);
            make.size.mas_equalTo(CGSizeMake(60.0f, 15.0f));
        }];
        
        [self.fastL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.gasSlider).with.offset(30.0f);
            make.top.equalTo(self.gasSlider.mas_bottom).with.offset(10.0f);
            make.size.mas_equalTo(CGSizeMake(60.0f, 15.0f));
        }];

        [self.currentGasPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.fastL.mas_left).with.offset(-5.0f);
            make.left.equalTo(self.slowL.mas_right).with.offset(5.0f);
            make.centerY.equalTo(self.slowL);
            make.height.mas_equalTo(15.0f);
        }];
        
//        [self.TotalEthTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.fastL.mas_left).with.offset(-5.0f);
//            make.left.equalTo(self.slowL.mas_right).with.offset(5.0f);
//            make.centerY.equalTo(self.slowL);
//            make.height.mas_equalTo(16.0f);
//        }];
        
        [self.totalETHL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.left.equalTo(self.contentView).with.offset(15.0f);
            make.bottom.equalTo(self.contentView).with.offset(-10.0f);
            make.height.mas_equalTo(15.0f);
        }];
    }
    
    return self;
}

- (UILabel *)currentGasSinglePriceL
{
    if (!_currentGasSinglePriceL) {
        _currentGasSinglePriceL = [[UILabel alloc] init];
        _currentGasSinglePriceL.font = [UIFont systemFontOfSize:13];
        _currentGasSinglePriceL.textAlignment = NSTextAlignmentRight;
        _currentGasSinglePriceL.text = @"当前gas单价：1.00 Gwei";
    }
    
    return _currentGasSinglePriceL;
}

- (UISlider *)gasSlider
{
    if (!_gasSlider) {
        _gasSlider = [[UISlider alloc] init];
        _gasSlider.minimumValue = 1;
        _gasSlider.maximumValue = 32;
        _gasSlider.value = 0;
    }
    
    return _gasSlider;
}

- (UILabel *)slowL
{
    if (!_slowL) {
        _slowL = [[UILabel alloc] init];
        _slowL.font = [UIFont systemFontOfSize:14];
        _slowL.textAlignment = NSTextAlignmentCenter;
        _slowL.text = SOLocalizedStringFromTable(@"slow", nil);
    }
    
    return _slowL;
}

- (UILabel *)fastL
{
    if (!_fastL) {
        _fastL = [[UILabel alloc] init];
        _fastL.font = [UIFont systemFontOfSize:14];
        _fastL.textAlignment = NSTextAlignmentCenter;
        _fastL.text = SOLocalizedStringFromTable(@"fast", nil);;
    }
    
    return _fastL;
}

- (UILabel *)currentGasPriceL
{
    if (!_currentGasPriceL) {
        _currentGasPriceL = [[UILabel alloc] init];
        _currentGasPriceL.textAlignment = NSTextAlignmentCenter;
        _currentGasPriceL.font = [UIFont systemFontOfSize:13];
        _currentGasPriceL.textColor = [UIColor lightGrayColor];
        _currentGasPriceL.text = @"3.00 Gwei";
    }
    
    return _currentGasPriceL;
}

//- (UILabel *)TotalEthTitle
//{
//    if (!_TotalEthTitle) {
//        _TotalEthTitle = [[UILabel alloc] init];
//        _TotalEthTitle.font = [UIFont systemFontOfSize:13];
//    }
//
//    return _TotalEthTitle;
//}

- (UILabel *)totalETHL
{
    if (!_totalETHL) {
        _totalETHL = [[UILabel alloc] init];
        _totalETHL.font = [UIFont systemFontOfSize:13];
        _totalETHL.textAlignment = NSTextAlignmentRight;
        _totalETHL.text = @"0.0000000045 ETH";
    }
    
    return _totalETHL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
