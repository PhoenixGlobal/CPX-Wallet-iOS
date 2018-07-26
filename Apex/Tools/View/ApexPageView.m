//
//  ApexPageView.m
//  Apex
//
//  Created by yulin chi on 2018/7/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexPageView.h"

@interface ApexPageSwitchHeader: UIView
@property (nonatomic, assign) NSInteger numOfPage;
@property (nonatomic, strong) NSMutableArray<UIButton*> *btnsArr; /**<  */
@property (nonatomic, strong) CAShapeLayer *indicator; /**<  */
@property (nonatomic, strong) UIView *lineV; /**<  */
@end

@implementation ApexPageSwitchHeader
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1.0/kScale)];
    _lineV.backgroundColor = [ApexUIHelper grayColor];
    [self addSubview:_lineV];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-2);
        make.height.mas_equalTo(2.0/kScale);
    }];
    _lineV.backgroundColor = [UIColor whiteColor];
    _lineV.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
    _lineV.layer.shadowOpacity = 0.8;
    _lineV.layer.shadowOffset = CGSizeMake(0, 3);
}

- (void)setNumOfPage:(NSInteger)numOfPage{
    _numOfPage = numOfPage;
    _btnsArr = [NSMutableArray array];
    
    CGFloat btnW = self.width/((CGFloat)numOfPage);
    
    for (NSInteger i = 0; i < numOfPage; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.frame = CGRectMake(btnW*i, 0, btnW, self.height);
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.btnsArr addObject:btn];
        [self insertSubview:btn atIndex:0];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.btnsArr.firstObject.mj_x, CGRectGetMaxY(self.btnsArr.firstObject.frame)-1.5)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.btnsArr.firstObject.frame), CGRectGetMaxY(self.btnsArr.firstObject.frame)-1.5)];
    self.indicator.path = path.CGPath;
    [self.layer addSublayer:self.indicator];
}

- (CAShapeLayer *)indicator{
    if (!_indicator) {
        _indicator = [[CAShapeLayer alloc] init];
        _indicator.fillColor = [ApexUIHelper mainThemeColor].CGColor;
        _indicator.strokeColor = [ApexUIHelper mainThemeColor].CGColor;
        _indicator.lineWidth = 3;
        _indicator.lineCap = kCALineCapRound;
    }
    return _indicator;
}
@end

/*************************************************************************************************************************************/

@interface ApexPageView()<UIScrollViewDelegate>
@property (nonatomic, strong) ApexPageSwitchHeader *switchHeader; /**<  */
@property (nonatomic, strong) UIScrollView *scrollView; /**<  */
@property (nonatomic, assign) NSInteger numOfPage; /**<  */
@property (nonatomic, assign) NSInteger currentPage; /**<  */
@property (nonatomic, assign) CGFloat itemWidth; /**<  */
@end

@implementation ApexPageView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self onSuperView];
}

#pragma mark - ------private------
- (void)onSuperView{
    
    if ([_delegate respondsToSelector:@selector(numberOfPageInPageView)]) {
        self.numOfPage = [_delegate numberOfPageInPageView];
        self.switchHeader.numOfPage = self.numOfPage;
        self.itemWidth = self.width/self.numOfPage;
        self.scrollView.contentSize = CGSizeMake(self.width*self.numOfPage, self.scrollView.height);
    }
    
    if ([_delegate respondsToSelector:@selector(pageView:viewForPageAtIndex:)]) {
        for (NSInteger i = 0; i < self.numOfPage; i++) {
            UIView *view = [_delegate pageView:self viewForPageAtIndex:i];
            view.frame = CGRectMake(self.scrollView.width*i, 0, self.scrollView.width, self.scrollView.height);
            [self.scrollView addSubview:view];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(pageView:titleForPageAtIndex:)]) {
        for (NSInteger i = 0; i < self.numOfPage; i++) {
            NSString *title = [_delegate pageView:self titleForPageAtIndex:i];
            UIButton *btn = ((UIButton*)self.switchHeader.btnsArr[i]);
            [btn addTarget:self action:@selector(headerDidClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [btn setTitleColor:[ApexUIHelper mainThemeColor] forState:UIControlStateSelected];
            i == 0 ? (btn.selected = YES) : (btn.selected = NO);
        }
    }
}

- (void)reloadData{
    [self onSuperView];
}

- (void)initUI{
    [self addSubview:self.switchHeader];
    [self addSubview:self.scrollView];
    
    [self.switchHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.switchHeader.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    
    
    _currentPage = 0;
}

- (void)unselectAll{
    for (UIButton *btn in self.switchHeader.btnsArr) {
        btn.selected = NO;
    }
}

- (void)scrollToPage:(NSInteger)page{
    _currentPage = page;
    [self unselectAll];
    UIButton *btn = ((UIButton*)self.switchHeader.btnsArr[page]);
    btn.selected = YES;
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_x = scrollView.contentOffset.x;
    CGFloat percent = offset_x / self.width;
    self.switchHeader.indicator.transform = CATransform3DMakeTranslation(self.itemWidth*percent, 0, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / kScreenW;
    [self scrollToPage:page];
}
#pragma mark - ------eventResponse------
- (void)headerDidClickBtn:(UIButton*)button{
    if (button.tag != self.currentPage) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.width * button.tag, 0);
        }];
        [self scrollToPage:button.tag];
    }
}
#pragma mark - ------getter & setter------
- (ApexPageSwitchHeader *)switchHeader{
    if (!_switchHeader) {
        _switchHeader = [[ApexPageSwitchHeader alloc] init];
    }
    return _switchHeader;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
@end
