//
//  ApexMoreFuncCell.m
//  Apex
//
//  Created by chinapex on 2018/6/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexMoreFuncCell.h"
@interface ApexMoreFuncCell()
@property (nonatomic, strong) ZJNButton *scanBtn;
@property (nonatomic, strong) ZJNButton *creatBtn;
@end

@implementation ApexMoreFuncCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self handleEvent];
    }
    return self;
}

#pragma mark - ------private-----
- (void)initUI{
    [self.contentView addSubview:self.scanBtn];
    [self.contentView addSubview:self.creatBtn];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [ApexUIHelper addLineInView:self.scanBtn color:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 15, 0, 0)];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(self.height/2.0);
    }];
    
    [self.creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanBtn.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(self.scanBtn);
    }];
}

- (void)handleEvent{
    [[self.scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self routeEventWithName:RouteNameEvent_FuncCellDidClickScan userInfo:@{}];
    }];
    
    [[self.creatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self routeEventWithName:RouteNameEvent_FuncCellDidClickCreat userInfo:@{}];
    }];
}

#pragma mark - ------setter getter-----
- (ZJNButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [[ZJNButton alloc] init];
        [_scanBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
        [_scanBtn setTitle:@"扫一扫\0" forState:UIControlStateNormal];
        _scanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_scanBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _scanBtn.contentMode = UIViewContentModeScaleAspectFill;
        _scanBtn.imagePosition = ZJNButtonImagePosition_Left;
        _scanBtn.spacingBetweenImageAndTitle = 10;
    }
    return _scanBtn;
}

- (ZJNButton *)creatBtn{
    if (!_creatBtn) {
        _creatBtn = [[ZJNButton alloc] init];
        [_creatBtn setImage:[UIImage imageNamed:@"Page 1"] forState:UIControlStateNormal];
        [_creatBtn setTitle:@"创建钱包" forState:UIControlStateNormal];
        _creatBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_creatBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _creatBtn.contentMode = UIViewContentModeScaleAspectFill;
        _creatBtn.imagePosition = ZJNButtonImagePosition_Left;
        _creatBtn.spacingBetweenImageAndTitle = 10;
    }
    return _creatBtn;
}
@end
