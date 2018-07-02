//
//  CYLEmptyView.m
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "CYLEmptyView.h"

@interface CYLEmptyView()
@property (nonatomic, strong) UIImageView *centerIv;
@property (nonatomic, strong) UILabel *messageL;
@property (nonatomic, strong) UIButton *refereshBtn;
@property (nonatomic, copy) dispatch_block_t refreshBlock;
@property (nonatomic, assign) CGFloat yOffset;
@end

@implementation CYLEmptyView

+ (instancetype)showEmptyViewOnView:(UIView *)superView emptyType:(CYLEmptyViewType)type message:(NSString *)message refreshBlock:(dispatch_block_t)block{
    CYLEmptyView *emptyView = [[CYLEmptyView alloc] initWithFrame:superView.bounds];
    emptyView.backgroundColor = superView.backgroundColor;
    emptyView.yOffset = -superView.height/8.0;
    type == CYLEmptyViewType_EmptyData ? (emptyView.centerIv.image = [UIImage imageNamed:@"Page 12"]) : (emptyView.centerIv.image = [UIImage imageNamed:@"Page 12"]);
    type == CYLEmptyViewType_EmptyData ? (emptyView.refereshBtn.hidden = YES) : (emptyView.refereshBtn.hidden = NO);
    emptyView.messageL.text = message;
    [emptyView prepareUI];
    
    for (UIView *ev in superView.subviews) {
        if ([ev isKindOfClass:CYLEmptyView.class]) {
            [ev removeFromSuperview];
        }
    }
    
    [superView addSubview:emptyView];
    
    return emptyView;
}

+ (instancetype)showEmptyViewOnView:(UIView *)superView y_offSet:(CGFloat)offsetY emptyType:(CYLEmptyViewType)type message:(NSString *)message refreshBlock:(dispatch_block_t)block{
    CYLEmptyView *emptyView = [[CYLEmptyView alloc] initWithFrame:superView.bounds];
    emptyView.backgroundColor = superView.backgroundColor;
    emptyView.yOffset = offsetY;
    type == CYLEmptyViewType_EmptyData ? (emptyView.centerIv.image = [UIImage imageNamed:@"Page 12"]) : (emptyView.centerIv.image = [UIImage imageNamed:@"Page 12"]);
    type == CYLEmptyViewType_EmptyData ? (emptyView.refereshBtn.hidden = YES) : (emptyView.refereshBtn.hidden = NO);
    emptyView.messageL.text = message;
    [emptyView prepareUI];
    [superView addSubview:emptyView];
    
    return emptyView;
}

#pragma mark - private
- (void)prepareUI{
    [self addSubview:self.centerIv];
    [self addSubview:self.messageL];
    [self addSubview:self.refereshBtn];
    
    [self.centerIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(self.yOffset);
        make.width.height.mas_equalTo(scaleWidth375(44));
    }];
    
    [self.messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerIv.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.refereshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageL.mas_bottom).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(scaleWidth375(80));
        make.height.mas_equalTo(40);
    }];
}


#pragma mark - setter getter
- (UIImageView *)centerIv{
    if (!_centerIv) {
        _centerIv = [[UIImageView alloc] init];
        _centerIv.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerIv;
}

- (UILabel *)messageL{
    if (!_messageL) {
        _messageL = [[UILabel alloc] init];
        _messageL.font = [UIFont systemFontOfSize:16];
        _messageL.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _messageL;
}

- (UIButton *)refereshBtn{
    if (!_refereshBtn) {
        _refereshBtn = [[UIButton alloc] init];
        [_refereshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        _refereshBtn.backgroundColor = [ApexUIHelper mainThemeColor];
        _refereshBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _refereshBtn.layer.cornerRadius = 6;
    }
    return _refereshBtn;
}

@end
