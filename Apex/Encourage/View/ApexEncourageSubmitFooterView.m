//
//  ApexEncourageSubmitFooterView.m
//  Apex
//
//  Created by 冯志勇 on 2018/8/28.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexEncourageSubmitFooterView.h"

@implementation ApexEncourageSubmitFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Page 1-3"]];
        [self.contentView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(30.0f);
            make.top.equalTo(self.contentView).with.offset(27.0f);
            make.size.mas_equalTo(CGSizeMake(13.0f, 13.0f));
        }];
        
        UILabel *activityDescribeLabel = [[UILabel alloc] init];
        activityDescribeLabel.font = [UIFont systemFontOfSize:13];
        activityDescribeLabel.numberOfLines = 0;
        activityDescribeLabel.text = SOLocalizedStringFromTable(@"Please be sure you have local NEO wallet, and the total amount of CPX should be equal or more than 100.", nil);
        activityDescribeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:activityDescribeLabel];
        [activityDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(25.0f, 50.0f, 15.0f, 40.0f));
        }];
    }
    
    return self;
}

@end
