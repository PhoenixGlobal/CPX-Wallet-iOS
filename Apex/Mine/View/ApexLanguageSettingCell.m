//
//  ApexLanguageSettingCell.m
//  Apex
//
//  Created by chinapex on 2018/7/17.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexLanguageSettingCell.h"

@interface ApexLanguageSettingCell()

@end

@implementation ApexLanguageSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select"]];
    [self.contentView addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.height.mas_equalTo(15);
    }];
    _imageV.hidden = YES;
}

@end
