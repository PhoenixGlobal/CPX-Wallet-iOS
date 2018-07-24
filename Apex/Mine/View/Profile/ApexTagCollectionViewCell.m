//
//  ApexTagCollectionViewCell.m
//  Apex
//
//  Created by yulin chi on 2018/7/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexTagCollectionViewCell.h"

@implementation ApexTagCollectionViewCell

#pragma mark - setter
- (void)setTagStr:(NSString *)tagStr{
    _tagStr = tagStr;
    self.mnemonicStr = tagStr;
}

@end
