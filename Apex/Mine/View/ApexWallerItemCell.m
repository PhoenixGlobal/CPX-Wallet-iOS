//
//  ApexWallerItemCell.m
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexWallerItemCell.h"

@implementation ApexWallerItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 6;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
