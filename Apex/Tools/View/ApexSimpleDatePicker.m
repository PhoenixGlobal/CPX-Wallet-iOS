//
//  ApexSimpleDatePicker.m
//  Apex
//
//  Created by yulin chi on 2018/7/25.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSimpleDatePicker.h"

@interface ApexSimpleDatePickerHeader : UIView
@property (nonatomic, strong) UIButton *cancleBtn; /**<  */
@property (nonatomic, strong) UIButton *confirmBtn; /**<  */
@end

@implementation ApexSimpleDatePickerHeader
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

/************************************************************************************************************************/
@interface ApexSimpleDatePicker()
@property (nonatomic, strong) UIView *coverView; /**<  */
@property (nonatomic, strong) UIDatePicker *datePickerView; /**<  */
@property (nonatomic, strong) ApexSimpleDatePickerHeader *header; /**<  */
@property (nonatomic, copy) didSelectDate completeHandler; /**<  */
@end

@implementation ApexSimpleDatePicker

+ (void)showDatePickerCompleteHandler:(didSelectDate)handler{
    ApexSimpleDatePicker *picker = [[ApexSimpleDatePicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
    picker.completeHandler = handler;
    [[UIApplication sharedApplication].keyWindow addSubview:picker];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        [self handleEvent];
    }
    return self;
}

#pragma mark - private
- (void)setUI{
    [self addSubview:self.coverView];
    [self addSubview:self.header];
    [self addSubview:self.datePickerView];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(200);
    }];
    
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.datePickerView);
        make.bottom.equalTo(self.datePickerView.mas_top);
        make.height.mas_equalTo(40);
    }];
}

- (void)dateChange:(UIDatePicker *)datePicker {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    //设置时间格式
//    formatter.dateFormat = @"yyyy年 MM月 dd日";
//    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
//    self.timeTextField.text = dateStr;
}

#pragma mark - eventHandler
- (void)handleEvent{
    [[self.header.cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self removeFromSuperview];
    }];
    
    [[self.header.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.completeHandler) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy年 MM月 dd日";
            NSString *dateStr = [formatter  stringFromDate:self.datePickerView.date];
            self.completeHandler(self.datePickerView.date, dateStr);
        }
        [self removeFromSuperview];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self removeFromSuperview];
    }];
    [self.coverView addGestureRecognizer:tap];
}

#pragma mark - getter
- (ApexSimpleDatePickerHeader *)header{
    if (!_header) {
        _header = [[ApexSimpleDatePickerHeader alloc] init];
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

- (UIDatePicker *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc] init];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        //设置地区: zh-中国
        _datePickerView.locale = [NSLocale localeWithLocaleIdentifier:[SOLocalization sharedLocalization].region];
        //设置日期模式(Displays month, day, and year depending on the locale setting)
        _datePickerView.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [_datePickerView setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_datePickerView setMaximumDate:[NSDate date]];
        //监听DataPicker的滚动
        [_datePickerView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePickerView;
}
@end
