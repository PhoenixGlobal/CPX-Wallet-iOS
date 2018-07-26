//
//  ApexRowSelectView.m
//  Apex
//
//  Created by yulin chi on 2018/7/25.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexRowSelectView.h"
#import "ApexQuestModel.h"

@interface ApexRowSelectPickerHeader : UIView
@property (nonatomic, strong) UIButton *cancleBtn; /**<  */
@property (nonatomic, strong) UIButton *confirmBtn; /**<  */
@end

@implementation ApexRowSelectPickerHeader
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _cancleBtn = [[UIButton alloc] init];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[ApexUIHelper mainThemeColor] forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _confirmBtn = [[UIButton alloc] init];
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[ApexUIHelper mainThemeColor] forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.cancleBtn];
    [self addSubview:self.confirmBtn];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.cancleBtn);
    }];
    
    [self addLinecolor:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
}
@end
/**********************************************************************************************************************************/
@interface ApexRowSelectView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIView *coverView; /**<  */
@property (nonatomic, strong) UIPickerView *pickerView; /**<  */
@property (nonatomic, strong) ApexRowSelectPickerHeader *header; /**<  */
@property (nonatomic, copy) didSelectRow handler; /**<  */
@property (nonatomic, strong) NSArray<ApexQuestItemBaseObject*> *contentArr; /**<  */
@property (nonatomic, strong) ApexQuestItemBaseObject *selectedmodel; /**<  */
@end

@implementation ApexRowSelectView

+ (void)showSingleRowSelectViewWithContentArr:(NSArray*)contentArr CompleteHandler:(didSelectRow)handler{
    ApexRowSelectView *view = [[ApexRowSelectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.handler = handler;
    view.contentArr = contentArr;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self handleEvent];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.coverView];
    [self addSubview:self.header];
    [self addSubview:self.pickerView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGFloat height = 200;
    if (self.contentArr.count * 50 < 200) {
        height = self.contentArr.count * 50;
    }
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(height);
    }];
    
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.pickerView);
        make.bottom.equalTo(self.pickerView.mas_top);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.contentArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UILabel *)view{
    if (view == nil) {
        view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = [UIColor colorWithHexString:@"000000"];
        view.textAlignment = NSTextAlignmentCenter;
        [view addLinecolor:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    }
    view.text = self.contentArr[row].name;
    return view;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedmodel = self.contentArr[row];
}

#pragma mark - eventHandler
- (void)handleEvent{
    [[self.header.cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self removeFromSuperview];
    }];
    
    [[self.header.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.handler) {
            self.handler(self.selectedmodel);
        }
        [self removeFromSuperview];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self removeFromSuperview];
    }];
    [self.coverView addGestureRecognizer:tap];
}

#pragma mark - getter setter
- (void)setContentArr:(NSArray<ApexQuestItemBaseObject *> *)contentArr{
    _contentArr = contentArr;
    self.selectedmodel = _contentArr.firstObject;
}

- (ApexRowSelectPickerHeader *)header{
    if (!_header) {
        _header = [[ApexRowSelectPickerHeader alloc] init];
        _header.backgroundColor = [UIColor whiteColor];
    }
    return _header;
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _coverView;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
@end




