//
//  ApexSearchWalletToolBar.m
//  Apex
//
//  Created by chinapex on 2018/5/23.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexSearchWalletToolBar.h"
@interface LeftViewSpaceTextField : UITextField

@end

@implementation LeftViewSpaceTextField
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 8; //像右边偏15
    return iconRect;
}

////UITextField 文字与输入框的距离
//- (CGRect)textRectForBounds:(CGRect)bounds{
//
//    return CGRectInset(bounds, 45, 0);
//
//}
//
////控制文本的位置
//- (CGRect)editingRectForBounds:(CGRect)bounds{
//
//    return CGRectInset(bounds, 45, 0);
//}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ApexSearchWalletToolBar()
@property (nonatomic, strong) LeftViewSpaceTextField *searchTF;
@property (nonatomic, strong) UIButton *cancleBtn;
@end

@implementation ApexSearchWalletToolBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.searchTF];
    [self addSubview:self.cancleBtn];
    
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(23);
        make.right.equalTo(self).offset(-23);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.searchTF).offset(-10);
        make.right.equalTo(self.searchTF).offset(-10);
        make.centerY.equalTo(self.searchTF.mas_centerY);
        make.width.height.mas_equalTo(15);
    }];
}

- (void)setTFBackColor:(UIColor*)color{
    _searchTF.backgroundColor = color;
}

- (void)clearEntrance{
    self.searchTF.text = @"";
}

#pragma mark - delegate
- (void)tfDidChangeChar{
    if (self.textDidChangeSub) {
        if (self.searchTF.text.length == 0) {
            _cancleBtn.hidden = YES;
        }else{
            _cancleBtn.hidden = false;
        }
        
        [self.textDidChangeSub sendNext:self.searchTF.text];
    }
}

#pragma mark - setter getter
- (void)setTextColor:(UIColor*)textColor backgroundColor:(UIColor *)bgColor{
    [self.cancleBtn setTitleColor:textColor forState:UIControlStateNormal];
    self.searchTF.backgroundColor = bgColor;
    self.searchTF.textColor = textColor;
}

- (void)setSearchTFLeftImage:(UIImage *)searchTFLeftImage{
    self.searchTF.leftView = [[UIImageView alloc] initWithImage:searchTFLeftImage];
}

- (void)setPlaceHolder:(NSString *)placeHolder color:(UIColor*)color{
    _placeHolder = placeHolder;
    self.searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}

- (void)setCancleBtnImage:(UIImage *)image{
    [self.cancleBtn setImage:image forState:UIControlStateNormal];
}

- (void)setLeftView:(UIView *)leftView{
    self.searchTF.leftView = leftView;
}

- (LeftViewSpaceTextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[LeftViewSpaceTextField alloc] init];
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _searchTF.borderStyle = UITextBorderStyleRoundedRect;
        _searchTF.layer.borderColor = [UIColor clearColor].CGColor;
        _searchTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.textColor = [UIColor whiteColor];
        _searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SOLocalizedStringFromTable(@"Wallet Address", nil) attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [_searchTF addTarget:self action:@selector(tfDidChangeChar) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTF;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc] init];
//        [_cancleBtn setTitle:SOLocalizedStringFromTable(@"Cancle", nil) forState:UIControlStateNormal];
//        [_cancleBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancleBtn setImage:[UIImage imageNamed:@"Group 5"] forState:UIControlStateNormal];
        _cancleBtn.hidden = YES;
        @weakify(self);
        [[_cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self clearEntrance];
            [self tfDidChangeChar];
        }];
    }
    return _cancleBtn;
}

@end
