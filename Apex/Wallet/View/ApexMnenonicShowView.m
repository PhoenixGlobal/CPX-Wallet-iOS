//
//  ApexMnenonicShowView.m
//  Apex
//
//  Created by chinapex on 2018/5/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexMnenonicShowView.h"
#import "ApexMnemonicShowCell.h"

@interface ApexMnenonicShowView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ApexMnenonicShowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}


- (void)initUI{
    self.delegate = self;
    self.dataSource = self;
    self.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.backgroundColor = [UIColor colorWithRed255:243 green255:248 blue255:254 alpha:1];
    [self registerClass:[ApexMnemonicShowCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)addNewWord:(NSString *)word{
    [self.selArr addObject:word];
    
    [self reloadData];
}

- (void)deleteWord:(NSString *)word{
    [self.selArr removeObject:word];
    
    [self reloadData];
}

#pragma mark - delegate datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    CGFloat version= [UIDevice currentDevice].systemVersion.floatValue;
    if (version < 11.0) {
        //11一下系统
        [self.collectionViewLayout invalidateLayout];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ApexMnemonicShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.showL.text = self.selArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *mnemonic = self.selArr[indexPath.row];
    [self deleteWord:mnemonic];
    [self routeEventWithName:RouteNameEvent_ShowViewDidDeselectWord userInfo:@{@"mnemonic":mnemonic}];
}


#pragma mark - setter getter
- (NSMutableArray *)selArr{
    if (!_selArr) {
        _selArr = [NSMutableArray array];
    }
    return _selArr;
}
@end
