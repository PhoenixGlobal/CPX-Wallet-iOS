//
//  ApexTagSelectCell.m
//  Apex
//
//  Created by yulin chi on 2018/7/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexTagSelectCell.h"
#import "ApexMnemonicFlowLayout.h"
#import "ApexTagCollectionViewCell.h"
#import "ApexQuestModel.h"

@interface ApexTagSelectCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView; /**<  */
@property (nonatomic, strong) NSLayoutConstraint *collectionViewH; /**<  */
@property (nonatomic, strong) UILabel *titleL; /**<  */
@end

@implementation ApexTagSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

#pragma mark - private
- (void)initUI{
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.titleL];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.titleL.mas_bottom).offset(5);
    }];
    [self.collectionView registerClass:[ApexTagCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    _collectionViewH = [self.collectionView.heightAnchor constraintEqualToConstant:0];
    
    @weakify(self);
    [RACObserve(self.collectionView, contentSize) subscribeNext:^(NSValue  *x) {
        @strongify(self);
        self.collectionViewH.constant = x.CGSizeValue.height;
        self.collectionViewH.active = YES;
    }];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ApexTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.tagStr = self.tags[indexPath.row].name;
    return cell;
}

#pragma mark - getter setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        ApexMnemonicFlowLayout *fl = [[ApexMnemonicFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.text = @"用户商业兴趣";
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}
@end
