//
//  ApexProfileQuestTextingController.m
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexProfileQuestTextingController.h"
#import "ApexQuestModel.h"

@interface ApexProfileQuestTextingController ()
@property (nonatomic, strong) UITextField *textingTF; /**<  */
@property (nonatomic, strong) UIButton *saveBtn; /**< b */
@property (nonatomic, strong) UILabel *titleL; /**<  */
@end

@implementation ApexProfileQuestTextingController
#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self setNav];
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}


#pragma mark - ------private------
- (void)initUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    self.view.backgroundColor = [ApexUIHelper grayColor240];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.textingTF];
    [self.textingTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10+NavBarHeight);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
}

- (void)setNav{
    UIImage *image = [UIImage imageNamed:@"back-4"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    
    self.navigationItem.titleView = self.titleL;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.textingTF.text.length > 0) {
            if (self.didConfirmTextSubject) {
                [self.didConfirmTextSubject sendNext:self.textingTF.text];
                [self back];
            }
        }else{
            if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
                [self showMessage:[NSString stringWithFormat:@"Please Input Your %@",self.model.title]];
            }else{
                [self showMessage:[NSString stringWithFormat:@"请填写你的%@",self.model.title]];
            }
        }
    }];
}

#pragma mark - ------getter & setter------
- (void)setModel:(ApexQuestModel *)model{
    _model = model;
    self.titleL.text = model.title;
    
    self.textingTF.placeholder = model.title;
    
    if ([model.title isEqualToString:@"居住地"] || [model.title isEqualToString:@"Location"]) {
        if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
            self.textingTF.placeholder = @"Ex: Shanghai China";
        }else{
            self.textingTF.placeholder = @"如: 中国 上海";
        }
    }
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleL.textColor = [UIColor blackColor];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:17];
    }
    return _titleL;
}

- (UITextField *)textingTF{
    if (!_textingTF) {
        _textingTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _textingTF.font = [UIFont systemFontOfSize:14];
        _textingTF.textColor = UIColorHex(999999);
        _textingTF.backgroundColor = [UIColor whiteColor];
        _textingTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _textingTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textingTF;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_saveBtn setTitle:SOLocalizedStringFromTable(@"Save", nil) forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _saveBtn;
}
@end
