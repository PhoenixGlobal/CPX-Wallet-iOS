//
//  ApexMorePanelView.m
//  Apex
//
//  Created by chinapex on 2018/5/22.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexMorePanelView.h"

@interface ApexMorePanelView()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *panelView;

@property (nonatomic, strong) ZJNButton *scanBtn;
@property (nonatomic, strong) ZJNButton *creatBtn;
@end

@implementation ApexMorePanelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - private
- (void)setUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.coverView];
    [self addSubview:self.panelView];
    [self.panelView addSubview:self.nameL];
    [self.panelView addSubview:self.scanBtn];
    [self.panelView addSubview:self.creatBtn];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(scaleWidth375(150));
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameL.superview);
        make.top.equalTo(self.nameL.superview).offset(20);
        make.height.mas_equalTo(scaleHeight667(50));
    }];
    
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameL.mas_bottom);
        make.left.right.equalTo(self.scanBtn.superview);
        make.height.mas_equalTo(scaleHeight667(50));
    }];
    
    [self.creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanBtn.mas_bottom);
        make.left.right.equalTo(self.creatBtn.superview);
        make.height.mas_equalTo(scaleHeight667(50));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        self.transform = CGAffineTransformMakeTranslation(-kScreenW, 0);
        self.hidden = YES;
    }];
    [self addGestureRecognizer:tap];
}

#pragma mark - getter
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return _coverView;
}

- (UIView *)panelView{
    if (!_panelView) {
        _panelView = [[UIView alloc] init];
        _panelView.backgroundColor = [UIColor whiteColor];
    }
    return _panelView;
}

-(UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
        _nameL.backgroundColor = [UIColor whiteColor];
        _nameL.text = @"Wallet 0x2334";
        _nameL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameL.textAlignment = NSTextAlignmentCenter;
        _nameL.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    }
    return _nameL;
}

- (ZJNButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [[ZJNButton alloc] init];
        [_scanBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
        [_scanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
        _scanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _scanBtn.contentMode = UIViewContentModeScaleAspectFit;
        _scanBtn.imagePosition = ZJNButtonImagePosition_Left;
        _scanBtn.spacingBetweenImageAndTitle = 10;
        [_scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _scanBtn.backgroundColor = [UIColor whiteColor];
        [[_scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteNameEvent_PanelViewScan userInfo:@{}];
        }];
    }
    return _scanBtn;
}

- (ZJNButton *)creatBtn{
    if (!_creatBtn) {
        _creatBtn = [[ZJNButton alloc] init];
        [_creatBtn setImage:[UIImage imageNamed:@"Page 1"] forState:UIControlStateNormal];
        [_creatBtn setTitle:@"创建钱包" forState:UIControlStateNormal];
        _creatBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _creatBtn.contentMode = UIViewContentModeScaleAspectFit;
        _creatBtn.imagePosition = ZJNButtonImagePosition_Left;
        _creatBtn.spacingBetweenImageAndTitle = 5;
        [_creatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _creatBtn.backgroundColor = [UIColor whiteColor];
        [[_creatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self routeEventWithName:RouteNameEvent_PanelViewCreatWallet userInfo:@{}];
        }];
    }
    return _creatBtn;
}
@end
