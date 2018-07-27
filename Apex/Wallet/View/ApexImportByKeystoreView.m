//
//  ApexImportByKeystoreView.m
//  Apex
//
//  Created by chinapex on 2018/6/6.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexImportByKeystoreView.h"
#import "ApexPrivacyAggreView.h"
#import "ApexAlertTextField.h"
#import "ApexProlicyController.h"

@interface ApexImportByKeystoreView()
@property (nonatomic, strong) UILabel *tipL;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ApexAlertTextField *passTF;
@property (nonatomic, strong) ApexPrivacyAggreView *agreeView;
@property (nonatomic, strong) UIButton *importBtn;
@property (nonatomic, strong) RACSignal *combineSignal;
@end

@implementation ApexImportByKeystoreView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self bindView];
        [self handleEvent];
    }
    return self;
}
#pragma mark - ------private-----
- (void)initUI{
    [self addSubview:self.tipL];
    [self addSubview:self.textView];
    [self addSubview:self.passTF];
    [self addSubview:self.agreeView];
    [self addSubview:self.importBtn];
    
    [self.tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipL.mas_bottom).offset(15);
        make.left.right.equalTo(self.tipL);
        make.height.mas_equalTo(130);
    }];
    
    [self.passTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(40);
        make.left.equalTo(self).offset(19);
        make.right.equalTo(self).offset(-49);
        make.height.mas_equalTo(40);
    }];
    
    [self.agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passTF.mas_bottom).offset(30);
        make.left.right.equalTo(self.passTF);
        make.height.mas_equalTo(20);
    }];
    
    [self.importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeView).offset(scaleHeight667(120));
        make.left.equalTo(self).offset(35);
        make.right.equalTo(self).offset(-35);
        make.height.mas_equalTo(40);
    }];
}

- (void)bindView{
    @weakify(self);
    RAC(self.importBtn, enabled) = self.combineSignal;
    [[RACObserve(self.importBtn, enabled) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        if (x.boolValue) {
            [self.importBtn setBackgroundColor:[ApexUIHelper mainThemeColor]];
        }else{
            [self.importBtn setBackgroundColor:[ApexUIHelper grayColor]];
        }
    }];
    self.importBtn.enabled = false;
}

- (void)handleEvent{
    [[[self.importBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self importWallet];
    }];
    
    self.agreeView.privacyAgreeLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSString *filePath = @"";
        if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
            filePath = [[NSBundle mainBundle] pathForResource:@"useprotocol_en" ofType:@"html"];
        }else{
            filePath = [[NSBundle mainBundle] pathForResource:@"useprotocol" ofType:@"html"];
        }
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        ApexProlicyController *vc = [[ApexProlicyController alloc] init];
        vc.html = htmlString;
        [[self topViewController].navigationController pushViewController:vc animated:YES];
    }];
    [self.agreeView.privacyAgreeLable addGestureRecognizer:tap];
}

- (void)importWallet{
    NSError *err = nil;
    NeomobileWallet *wallet = NeomobileFromKeyStore(self.textView.text, self.passTF.text, &err);
    if (err) {
        [[self topViewController] showMessage:SOLocalizedStringFromTable(@"Import Wallet Failed", nil)];
        return;
    }
    
    NSError *keystoreErr = nil;
    NSString *keystore = [wallet toKeyStore:self.passTF.text error:&keystoreErr];
    if (keystoreErr) {
        [[self topViewController] showMessage:[NSString stringWithFormat:@"%@: %@",SOLocalizedStringFromTable(@"Create Keystore Failed", nil) ,keystoreErr]];
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
#pragma mark - ------getter-----
- (RACSignal *)combineSignal{
    if (!_combineSignal) {
        _combineSignal = [RACSignal combineLatest:@[self.textView.rac_textSignal, RACObserve(self.passTF, isAlertShowing), RACObserve(self.agreeView.privacyAgreeBtn, selected)] reduce:^id (NSString *string, NSNumber *isAlert, NSNumber *privaceSel){
            BOOL flag = true;
            
            if (string.length == 0 || isAlert.boolValue == YES || privaceSel.boolValue == false) {
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
        _textView.layer.cornerRadius = 2;
        _textView.layer.borderWidth = 0.6;
        _textView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _textView.layer.masksToBounds = YES;
        _textView.font = [UIFont systemFontOfSize:13];
        //调用私有方法
        [_textView setPlaceholder:@"Keystore" placeholdColor:[UIColor lightGrayColor]];
    }
    return _textView;
}

- (UILabel *)tipL{
    if (!_tipL) {
        _tipL = [[UILabel alloc] init];
        _tipL.text = SOLocalizedStringFromTable(@"Input Keystore Text Here", nil);
        _tipL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _tipL.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _tipL.numberOfLines = 0;
    }
    return _tipL;
}

- (ApexAlertTextField *)passTF{
    if (!_passTF) {
        _passTF = [[ApexAlertTextField alloc] initWithFrame:CGRectZero];
        _passTF.font = [UIFont systemFontOfSize:13];
        _passTF.floatingLabelYPadding = 5;
        // 浮动式标签的正常字体颜色
        _passTF.floatingLabelTextColor = [UIColor colorWithHexString:@"555555"];
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _passTF.floatingLabelActiveTextColor = [ApexUIHelper mainThemeColor];
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _passTF.keepBaseline = YES;
        // 设置占位符文字和浮动式标签的文字.
        [_passTF setPlaceholder:SOLocalizedStringFromTable(@"Password", nil)
                              floatingTitle:SOLocalizedStringFromTable(@"Password", nil)];
        _passTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        @weakify(self);
        _passTF.alertString = SOLocalizedStringFromTable(@"Password Too Short", nil);
        _passTF.alertShowConditionBlock = ^BOOL(NSString *text) {
            
            if (text.length > 0) {
                return false;
            }
            return true;
        };
        
        _passTF.secureTextEntry = YES;
    }
    return _passTF;
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
        [_importBtn setTitle:SOLocalizedStringFromTable(@"Import", nil) forState:UIControlStateNormal];
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
