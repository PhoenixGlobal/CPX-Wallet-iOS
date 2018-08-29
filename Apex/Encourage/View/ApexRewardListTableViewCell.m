//
//  ApexRewardListTableViewCell.m
//  Apex
//
//  Created by 冯志勇 on 2018/8/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexRewardListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ApexRewardListTableViewCell ()

@property (nonatomic, strong) UIImageView *rewardImageView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation ApexRewardListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        self.layer.borderWidth = 1.0/kScale;
        
        _rewardImageView = [[UIImageView alloc] init];
        _rewardImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rewardImageView.clipsToBounds = YES;
        [self.contentView addSubview:_rewardImageView];
        [_rewardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(((SCREEN_WIDTH - 30.0f) * 2 / 5));
        }];
        _rewardImageView.hidden = YES;
        
        UIImageView *newImagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new"]];
        newImagView.tag = 2000;
        [self.contentView addSubview:newImagView];
        [newImagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        }];
        newImagView.hidden = YES;
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.layer.cornerRadius = 10.0f;
        _statusLabel.clipsToBounds = YES;
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_statusLabel];
        [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).with.offset(-10.0f);
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.size.mas_equalTo(CGSizeMake(80.0f, 20.0f));
        }];
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:18];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:_descriptionLabel];
        [_descriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).with.offset(-10.0f - 25.0f);
            make.left.equalTo(self.contentView).with.offset(10.0f);
            make.right.equalTo(self.contentView).with.offset(-10.0f);
            make.height.mas_equalTo(20.0f);
        }];
        
    }
    
    return self;
}

- (void)updaetRewardWithDictionary:(ApexEncourageActivitysModel *)model
{
    UIImageView *newImagView = (UIImageView *)[self.contentView viewWithTag:2000];
    
    NSString *showImage = model.imagesurl;
    NSString *labeiString = @"";
    NSString *currentStatus = [NSString stringWithFormat:@"%@", model.status];
    NSString *isNew = [NSString stringWithFormat:@"%@", model.flag];
    
    if (![showImage isEqualToString:@""]) {
        _rewardImageView.hidden = NO;
        [_rewardImageView sd_setImageWithURL:[NSURL URLWithString:showImage]];
    }
    else {
        _rewardImageView.hidden = YES;
    }
    
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        labeiString = model.title_en;
        newImagView.image = [UIImage imageNamed:@"new_en"];
    }
    else {
        labeiString = model.title_cn;
        newImagView.image = [UIImage imageNamed:@"new"];
    }
    
    newImagView.hidden = ![isNew isEqualToString:@"1"];
    
    CGFloat labelHeght = [ApexUIHelper calculateTextHeight:[UIFont systemFontOfSize:18] givenText:labeiString givenWidth:SCREEN_WIDTH - 30.0f - 20.0f];
    
    NSString *statusString = @"";
    CGFloat statusWidth = 0;
    if ([currentStatus isEqualToString:@"-1"]) {
        statusString = @"About to begin";
        _statusLabel.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
        _statusLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    else if ([currentStatus isEqualToString:@"1"]) {
        statusString = @"In progress";
        _statusLabel.backgroundColor = [UIColor colorWithHexString:@"4C8EFA"];
        _statusLabel.textColor = [UIColor whiteColor];
    }
    else if ([currentStatus isEqualToString:@"2"]) {
        statusString = @"Closed";
        _statusLabel.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
        _statusLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    
    statusWidth = [ApexUIHelper calculateTextLength:[UIFont systemFontOfSize:12] givenText:SOLocalizedStringFromTable(statusString, nil)];
    
    [_descriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(labelHeght);
    }];
    
    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(statusWidth + 20.0f, 20.0f));
    }];
    
    _descriptionLabel.text = labeiString;
    _statusLabel.text = SOLocalizedStringFromTable(statusString, nil);
}

+ (CGFloat)getContentHeightWithDictionary:(ApexEncourageActivitysModel *)model
{
    CGFloat totalHeight = 50.0f;
    
    NSString *showImage = model.imagesurl;
    NSString *labeiString = @"";
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        labeiString = model.title_en;
    }
    else {
        labeiString = model.title_cn;
    }
    if (![showImage isEqualToString:@""]) {
        totalHeight += ((SCREEN_WIDTH - 30.0f) * 2 / 5);
    }
    
    return totalHeight + [ApexUIHelper calculateTextHeight:[UIFont systemFontOfSize:18] givenText:labeiString givenWidth:SCREEN_WIDTH - 30.0f - 20.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
