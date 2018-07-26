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
    
    if ([model.userSelection isKindOfClass:ApexQuestItemBaseObject.class]) {
        self.detailTextLabel.text = ((ApexQuestItemBaseObject*)model.userSelection).name;
    }else if ([model.userSelection isKindOfClass:NSString.class]){
        self.detailTextLabel.text = ((NSString*)model.userSelection);
    }
    
    if (model.type == ApexQuestType_Local) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.detailTextLabel.text = @"S-coffee";
    }
}
@end
