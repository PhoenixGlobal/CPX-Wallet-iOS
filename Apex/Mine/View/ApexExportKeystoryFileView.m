//
//  ApexExportKeystoryFileView.m
//  Apex
//
//  Created by chinapex on 2018/6/7.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexExportKeystoryFileView.h"

@interface ApexExportKeystoryFileView()
@property (weak, nonatomic) IBOutlet UILabel *title0;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;

@property (weak, nonatomic) IBOutlet UILabel *detail0;
@property (weak, nonatomic) IBOutlet UILabel *detail1;
@property (weak, nonatomic) IBOutlet UILabel *detail2;

@end

@implementation ApexExportKeystoryFileView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.textView.layer.borderColor = [ApexUIHelper grayColor].CGColor;
    self.textView.layer.borderWidth = 1.0/kScale;
    
    self.textView.editable = false;
    [self.ksBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyAction)];
    [self.textView addGestureRecognizer:tap];
    
    _title0.text = SOLocalizedStringFromTable(@"saveofflin", nil);
    _title1.text = SOLocalizedStringFromTable(@"dontTransThNet", nil);
    _title2.text = SOLocalizedStringFromTable(@"saveinbox", nil);
    
    _detail0.text = SOLocalizedStringFromTable(@"jOA-VA-35F.text", nil);
    _detail1.text = SOLocalizedStringFromTable(@"DZw-7m-c91.text", nil);
    _detail2.text = SOLocalizedStringFromTable(@"QUv-UT-8CI.text", nil);
    
    [_ksBtn setTitle:SOLocalizedStringFromTable(@"GeD-5D-bhg.normalTitle", nil) forState:UIControlStateNormal];
}

- (void)setModel:(ApexWalletModel *)model{
    _model = model;
    NSString *ks = [PDKeyChain load:KEYCHAIN_KEY(model.address)];
    self.textView.text = ks;
}


- (void)copyAction{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.textView.text;
    [[self topViewController] showMessage:SOLocalizedStringFromTable(@"copyKeystore", nil)];

//    [_btn setTitle:@"已复制" forState:UIControlStateNormal];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.btn setTitle:@"复制收款地址" forState:UIControlStateNormal];
//
//    });
}
@end
