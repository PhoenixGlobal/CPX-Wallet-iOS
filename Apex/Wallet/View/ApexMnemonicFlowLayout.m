//
//  ApexMnemonicFloyLayout.m
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexMnemonicFlowLayout.h"

#define LineSpacing 5
#define InteritemSpacing 5

@implementation ApexMnemonicFlowLayout

-(void)prepareLayout{
    [super prepareLayout];
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.estimatedItemSize = CGSizeMake(70, 30);
    self.minimumLineSpacing = LineSpacing;
    self.minimumInteritemSpacing = InteritemSpacing;
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    if (attributes.count == 1) {
        UICollectionViewLayoutAttributes *currentAttribute = attributes.firstObject;
        CGRect frame = currentAttribute.frame;
        frame.origin.x = self.sectionInset.left;
        currentAttribute.frame = frame;
        return attributes;
    }
    for (int i = 0; i < attributes.count; i++) {
        UICollectionViewLayoutAttributes *currentAttribute = attributes[i];
        UICollectionViewLayoutAttributes *firstAttribute = attributes[0];
        if (currentAttribute.frame.origin.x != firstAttribute.frame.origin.x) {
            UICollectionViewLayoutAttributes *previousAttribute = attributes[i-1];
            CGRect frame = currentAttribute.frame;
            frame.origin.x = CGRectGetMaxX(previousAttribute.frame)+ InteritemSpacing;
            currentAttribute.frame = frame;
            
        }
    }
    
    return attributes;
}

@end
