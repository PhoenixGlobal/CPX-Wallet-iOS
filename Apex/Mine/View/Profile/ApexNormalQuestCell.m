//
//  ApexNormalQuestCell.m
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexNormalQuestCell.h"
#import "ApexQuestModel.h"

@implementation ApexNormalQuestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.detailTextLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
}

- (void)setModel:(ApexQuestModel *)model{
    _model = model;
    self.textLabel.text = model.title;
}

#warning 半夜三点写的代码 待优化
- (void)setShowDict:(NSDictionary *)showDict{
    _showDict = showDict;
        NSString *bindingAddress = [TKFileManager ValueWithKey:KBindingWalletAddress];
        if (bindingAddress) {
            NSDictionary *dcit = showDict;
            if ([dcit.allKeys containsObject:self.model.title]) {
                id any = dcit[self.model.title];
                if ([any isKindOfClass:NSString.class]) {
                    self.detailTextLabel.text = any;
                }else if([any isKindOfClass:ApexQuestItemBaseObject.class]){
                    self.detailTextLabel.text = ((ApexQuestItemBaseObject*)any).name;
                }
            }else{
                self.detailTextLabel.text = @"";
            }
        }
}
@end
