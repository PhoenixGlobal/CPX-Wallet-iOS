//
//  ApexMnemonicConfirmController.m
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexMnemonicConfirmController.h"
#import "ApexMnemonicCell.h"
#import "ApexMnemonicFlowLayout.h"

@interface ApexMnemonicConfirmController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) NSArray *contentArr;
@property (nonatomic, strong) NSMutableArray *choosenArr;
@property (weak, nonatomic) IBOutlet ApexMnemonicFlowLayout *flowLayout;

@end

@implementation ApexMnemonicConfirmController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor colorWithRed255:70 green255:105 blue255:214 alpha:1]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)initUI{
    self.title = @"备份钱包";
    _choosenArr = [NSMutableArray array];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[ApexMnemonicCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.textView.layer.shadowOffset = CGSizeMake(0, 1);
    self.textView.layer.shadowOpacity = 0.63;
    self.textView.userInteractionEnabled = NO;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 1.5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _textView.typingAttributes = attributes;
    
    self.confirmBtn.layer.cornerRadius = 6;
    
}

- (void)prepareData{
    self.contentArr = [self.mnemonic componentsSeparatedByString:@" "];
    self.contentArr = [self.contentArr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ApexMnemonicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.mnemonicStr = self.contentArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ApexMnemonicCell *cell = (ApexMnemonicCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.choose = !cell.choose;
    
    if (cell.choose) {
        [_choosenArr addObject:cell.mnemonicStr];
    }else{
        [_choosenArr removeObject:cell.mnemonicStr];
    }
    
    self.textView.text = [_choosenArr componentsJoinedByString:@" "];
}

#pragma mark - ------eventResponse------
- (IBAction)confirmAction:(id)sender {
    if ([self.textView.text isEqualToString:self.mnemonic]) {
        [self showMessage:@"备份成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self showMessage:@"备份失败"];
    }
}
#pragma mark - ------getter & setter------

@end


