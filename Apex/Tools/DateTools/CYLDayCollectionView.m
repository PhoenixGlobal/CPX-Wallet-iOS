//
//  CYLDayCollectionView.m
//  CYLTimePicker
//
//  Created by 迟钰林 on 2017/6/22.
//  Copyright © 2017年 迟钰林. All rights reserved.
//

#import "CYLDayCollectionView.h"

@implementation CYLDayCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    return [super initWithFrame:frame collectionViewLayout:_flowLayout];
}

@end
