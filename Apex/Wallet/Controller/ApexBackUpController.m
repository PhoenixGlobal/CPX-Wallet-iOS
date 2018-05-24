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

@end

@implementation ApexBackUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor colorWithRed255:70 green255:105 blue255:214 alpha:1]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)initUI{
    self.title = @"备份钱包";
    
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
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

@end
