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
@property (nonatomic, strong) ZJNButton *importBtn;
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
    [self.contentView addSubview:self.importBtn];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat count = self.configArr.count;
    UIView *lastBtn = nil;
    for (NSNumber *num in self.configArr) {
        
        if (num.integerValue == PanelFuncConfig_Scan) {
            if(!lastBtn) lastBtn = self;
            [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastBtn);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(self.height/count);
            }];
            lastBtn = self.scanBtn;
//            [ApexUIHelper addLineInView:self.scanBtn color:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 15, 0, 0)];
            
        }else if (num.integerValue == PanelFuncConfig_Create){
            
            if(!lastBtn) lastBtn = self;
            [self.creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo([lastBtn isKindOfClass:ApexMoreFuncCell.class] ? lastBtn : lastBtn.mas_bottom);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(self.height/count);
            }];
            lastBtn = self.creatBtn;
//            [ApexUIHelper addLineInView:self.creatBtn color:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 15, 0, 0)];
            
        }else if (num.integerValue == PanelFuncConfig_Import){
            
            if(!lastBtn) lastBtn = self;
            [self.importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo([lastBtn isKindOfClass:ApexMoreFuncCell.class] ? lastBtn : lastBtn.mas_bottom);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(self.height/count);
            }];
            lastBtn = self.importBtn;
//            [ApexUIHelper addLineInView:self.importBtn color:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 15, 0, 0)];
        }
        
    }
}

- (void)handleEvent{
    [[self.scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self routeEventWithName:RouteNameEvent_FuncCellDidClickScan userInfo:@{}];
    }];
    
    [[self.creatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self routeEventWithName:RouteNameEvent_FuncCellDidClickCreat userInfo:@{}];
    }];
    
    [[self.importBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self routeEventWithName:RouteNameEvent_FuncCellDidClickImport userInfo:@{}];
    }];
}

#pragma mark - ------setter getter-----
- (ZJNButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [[ZJNButton alloc] init];
        [_scanBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
        [_scanBtn setTitle:SOLocalizedStringFromTable(@"Scan", nil) forState:UIControlStateNormal];
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
        [_creatBtn setTitle:SOLocalizedStringFromTable(@"Create Wallet", nil) forState:UIControlStateNormal];
        _creatBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_creatBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _creatBtn.contentMode = UIViewContentModeScaleAspectFill;
        _creatBtn.imagePosition = ZJNButtonImagePosition_Left;
        _creatBtn.spacingBetweenImageAndTitle = 10;
    }
    return _creatBtn;
}

- (ZJNButton *)importBtn{
    if (!_importBtn) {
        _importBtn = [[ZJNButton alloc] init];
        [_importBtn setImage:[UIImage imageNamed:@"Page 13"] forState:UIControlStateNormal];
        [_importBtn setTitle:SOLocalizedStringFromTable(@"Import Wallet", nil) forState:UIControlStateNormal];
        _importBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_importBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _importBtn.contentMode = UIViewContentModeScaleAspectFit;
        _importBtn.imagePosition = ZJNButtonImagePosition_Left;
        _importBtn.spacingBetweenImageAndTitle = 10;
    }
    return _importBtn;
}
@end
