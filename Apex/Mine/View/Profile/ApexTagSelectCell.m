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

@interface ApexTagSelectCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet ApexMnemonicFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;

@end

@implementation ApexTagSelectCell
@synthesize tags = _tags;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:ApexTagCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    
    [[RACObserve(self.collectionView, contentSize) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSValue *x) {
        self.collectionViewH.constant = x.CGSizeValue.height;
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
    cell.baseColor = UIColorHex(66BB6A);
    ApexQuestItemBaseObject *obj = self.tags[indexPath.row];
    cell.tagStr = obj.name;
    if ([self.selectedTags containsObject:obj]) {
        cell.choose = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ApexTagCollectionViewCell *cell = (ApexTagCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.choose = !cell.choose;
    
    if (cell.choose) {
        [self.selectedTags addObject:self.tags[indexPath.row]];
    }else{
        [self.selectedTags removeObject:self.tags[indexPath.row]];
    }
}

#pragma mark - getter
- (void)setTags:(NSArray<ApexQuestItemBaseObject *> *)tags{
    _tags = tags;
    
    if (_isFromCommon) {
        NSString *bindingAddress = [TKFileManager ValueWithKey:KBindingWalletAddress];
        if (bindingAddress) {
            NSDictionary *dcit = [PDKeyChain load:KBindingAddressToCommonProfile(bindingAddress)];
            if ([dcit.allKeys containsObject:self.titleL.text]) {
                self.selectedTags = dcit[self.titleL.text];
            }
        }
    }
}

- (NSArray *)tags{
    if (!_tags) {
        _tags = [NSArray array];
    }
    return _tags;
}

- (NSMutableArray *)selectedTags{
    if (!_selectedTags) {
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
}
@end
