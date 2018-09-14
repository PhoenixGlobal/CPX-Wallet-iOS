//
//  ApexBackUpController.m
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexBackUpController.h"
#import "ApexMnemonicConfirmController.h"

@interface ApexBackUpController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipLable01;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipLable3;

@end

@implementation ApexBackUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[ApexUIHelper mainThemeColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)initUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = SOLocalizedStringFromTable(@"Backup Wallet", nil);
    [self.nextBtn setTitle:SOLocalizedStringFromTable(@"Next step", nil) forState:UIControlStateNormal];
    _tipLable01.text = SOLocalizedStringFromTable(@"Copy Your Mnemonic", nil);
    _tipLabel2.text = SOLocalizedStringFromTable(@"The mnemonic is used to recover the wallet or repeat the wallet password, copy it to the paper accurately, and store it in a safe place that only you know.", nil);
    _tipLable3.text = SOLocalizedStringFromTable(@"Do not take screenshots,  someone will have fully accecss to your assets ,if it gets your mnemonic! Please copy the mnemonic, then store it at a safe place.", nil);
    
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.textView.layer.shadowOffset = CGSizeMake(0, 1);
    self.textView.layer.shadowOpacity = 0.63;
    self.textView.userInteractionEnabled = NO;
    self.textView.text = self.mnemonic;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    
    self.nextBtn.layer.cornerRadius = 6;
    
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApexMnemonicConfirmController *vc = [[ApexMnemonicConfirmController alloc] init];
        vc.mnemonic = self.mnemonic;
        vc.model = self.model;
        vc.BackupCompleteBlock = self.BackupCompleteBlock;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

@end
