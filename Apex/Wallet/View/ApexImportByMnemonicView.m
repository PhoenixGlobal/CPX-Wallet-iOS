//
//  ApexImportByMnemonicView.m
//  Apex
//
//  Created by chinapex on 2018/6/6.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexImportByMnemonicView.h"
#import "ApexAlertTextField.h"
#import "ApexPrivacyAggreView.h"

@interface ApexImportByMnemonicView()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ApexAlertTextField *passWordTF;
@property (nonatomic, strong) ApexAlertTextField *repeatPassWTF;
@property (nonatomic, strong) ApexPrivacyAggreView *agreeView;
@property (nonatomic, strong) UIButton *importBtn;
@property (nonatomic, strong) RACSignal *combineSignal;
@end

@implementation ApexImportByMnemonicView
#pragma mark - ------life cycle------
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self handleEvent];
    }
    return self;
}


#pragma mark - ------private------
- (void)initUI{
    
    RAC(self.importBtn, enabled) = self.combineSignal;
    
    [self addSubview:self.textView];
    [self addSubview:self.passWordTF];
    [self addSubview:self.repeatPassWTF];
    [self addSubview:self.agreeView];
    [self addSubview:self.importBtn];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(scaleHeight667(130));
    }];
    
    [self.passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
        make.left.right.equalTo(self.textView);
    }];
    
    [self.repeatPassWTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passWordTF.mas_bottom).offset(30);
        make.height.left.right.equalTo(self.passWordTF);
    }];
    
    [self.agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.repeatPassWTF.mas_bottom).offset(30);
        make.left.right.equalTo(self.repeatPassWTF);
        make.height.mas_equalTo(20);
    }];
    
    [self.importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeView).offset(scaleHeight667(120));
        make.left.equalTo(self).offset(35);
        make.right.equalTo(self).offset(-35);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (void)handleEvent{
    [[self.importBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self importWallet];
    }];
}

- (void)importWallet{
    NSError *err = nil;
    NeomobileWallet *wallet = NeomobileFromMnemonic(self.textView.text, mnemonicEnglish, &err);
    if (err) {
        [[self topViewController] showMessage:SOLocalizedStringFromTable(@"Import Wallet Fail", nil)];
        return;
    }
    
    NSError *keystoreErr = nil;
    NSString *keystore = [wallet toKeyStore:self.passWordTF.text error:&keystoreErr];
    if (keystoreErr) {
        [[self topViewController] showMessage:[NSString stringWithFormat:@"%@: %@",SOLocalizedStringFromTable(@"Create Keystore Fail", nil),keystoreErr]];
        return;
    }
    
    NSString *address = wallet.address;
    
    [PDKeyChain save:KEYCHAIN_KEY(address) data:keystore];
    
    for (ApexWalletModel *model in [ApexWalletManager getWalletsArr]) {
        if ([model.address isEqualToString:address]) {
            [[self topViewController] showMessage:SOLocalizedStringFromTable(@"Wallet Exist", nil)];
            return;
        }
    }
    
    //删除已有的 再添加新的
    [ApexWalletManager deleteWalletForAddress:address];
    [ApexWalletManager saveWallet:[NSString stringWithFormat:@"%@/%@",address, @"Wallet"]];
    
    [[self topViewController] showMessage:SOLocalizedStringFromTable(@"Import Wallet Success", nil)];
    if (self.didFinishImportSub) {
        [self.didFinishImportSub sendNext:@""];
    }else{
        [[self topViewController].navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - ------eventResponse------

#pragma mark - ------getter & setter------
- (RACSignal *)combineSignal{
    if (!_combineSignal) {
        _combineSignal = [RACSignal combineLatest:@[self.textView.rac_textSignal, self.passWordTF.rac_textSignal,self.repeatPassWTF.rac_textSignal,RACObserve(self.passWordTF, isAlertShowing), RACObserve(self.repeatPassWTF, isAlertShowing), RACObserve(self.agreeView.privacyAgreeBtn, selected)] reduce:^id (NSString *mnemonic, NSString *passw, NSString *repeat, NSNumber *passAlert, NSNumber *repeatAlert, NSNumber *privacySel){
            BOOL flag = true;
            
            if ([mnemonic componentsSeparatedByString:@" "].count == 0) {
                flag = false;
            }
            
            if (passAlert.boolValue == true || repeatAlert.boolValue == true || privacySel.boolValue == false) {
                flag = false;
            }
            
            return @(flag);
        }];
    }
    return _combineSignal;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 300, 300, 60)];
        _textView.layer.cornerRadius = 2;
        _textView.layer.borderWidth = 0.6;
        _textView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _textView.layer.masksToBounds = YES;
        _textView.font = [UIFont systemFontOfSize:13];
        //调用私有方法
        [_textView setPlaceholder:SOLocalizedStringFromTable(@"Input Mnemonics Seperated By Blank Space", nil) placeholdColor:[UIColor lightGrayColor]];
    }
    return _textView;
}

- (ApexAlertTextField *)passWordTF{
    if (!_passWordTF) {
        _passWordTF = [[ApexAlertTextField alloc] initWithFrame:CGRectZero];
        _passWordTF.font = [UIFont systemFontOfSize:13];
        _passWordTF.floatingLabelYPadding = 5;
        // 浮动式标签的正常字体颜色
        _passWordTF.floatingLabelTextColor = [UIColor colorWithHexString:@"555555"];
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _passWordTF.floatingLabelActiveTextColor = [ApexUIHelper mainThemeColor];
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _passWordTF.keepBaseline = YES;
        // 设置占位符文字和浮动式标签的文字.
        [_passWordTF setPlaceholder:@"密码(不少于6个字符)"
                      floatingTitle:@"密码"];
        _passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _passWordTF.alertString = @"输入密码太短";
        _passWordTF.alertShowConditionBlock = ^BOOL(NSString *text) {
            
            if (text.length >= 6) {
                return false;
            }
            return true;
        };
        
        _passWordTF.secureTextEntry = YES;
    }
    return _passWordTF;
}

- (ApexAlertTextField *)repeatPassWTF{
    if (!_repeatPassWTF) {
        _repeatPassWTF = [[ApexAlertTextField alloc] initWithFrame:CGRectZero];
        _repeatPassWTF.font = [UIFont systemFontOfSize:13];
        _repeatPassWTF.floatingLabelYPadding = 5;
        // 浮动式标签的正常字体颜色
        _repeatPassWTF.floatingLabelTextColor = [UIColor colorWithHexString:@"555555"];
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _repeatPassWTF.floatingLabelActiveTextColor = [ApexUIHelper mainThemeColor];
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _repeatPassWTF.keepBaseline = YES;
        // 设置占位符文字和浮动式标签的文字.
        [_repeatPassWTF setPlaceholder:@"重复密码(不少于6个字符)"
                         floatingTitle:@"重复密码"];
        _repeatPassWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        @weakify(self);
        _repeatPassWTF.alertString = @"输入密码不相符";
        _repeatPassWTF.alertShowConditionBlock = ^BOOL(NSString *text) {
            @strongify(self)
            
            if ([text isEqualToString:self.passWordTF.text]) {
                return false;
            }
            return true;
        };
        
        _repeatPassWTF.secureTextEntry = YES;
    }
    return _repeatPassWTF;
}

- (ApexPrivacyAggreView *)agreeView{
    if (!_agreeView) {
        _agreeView = [[ApexPrivacyAggreView alloc] init];
    }
    return _agreeView;
}

- (UIButton *)importBtn{
    if (!_importBtn) {
        _importBtn = [[UIButton alloc] init];
        _importBtn.backgroundColor = [ApexUIHelper mainThemeColor];
        _importBtn.layer.cornerRadius = 5;
        _importBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_importBtn setTitle:@"开始导入" forState:UIControlStateNormal];
        [[RACObserve(_importBtn, enabled) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *x) {
            if (x.boolValue) {
                [_importBtn setBackgroundColor:[ApexUIHelper mainThemeColor]];
            }else{
                [_importBtn setBackgroundColor:[ApexUIHelper grayColor]];
            }
        }];
        _importBtn.enabled = false;
    }
    return _importBtn;
}
@end
