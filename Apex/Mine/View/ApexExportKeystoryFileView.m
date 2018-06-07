//
//  ApexExportKeystoryFileView.m
//  Apex
//
//  Created by chinapex on 2018/6/7.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexExportKeystoryFileView.h"

@implementation ApexExportKeystoryFileView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.textView.layer.borderColor = [ApexUIHelper grayColor].CGColor;
    self.textView.layer.borderWidth = 1.0/kScale;
    
    self.textView.editable = false;
    [self.ksBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyAction)];
    [self.textView addGestureRecognizer:tap];
}

- (void)setAddress:(NSString *)address{
    _address = address;
    
    NSString *ks = [PDKeyChain load:KEYCHAIN_KEY(address)];
    self.textView.text = ks;
}


- (void)copyAction{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.textView.text;
    [[self topViewController] showMessage:@"keystore已复制到剪切板"];

//    [_btn setTitle:@"已复制" forState:UIControlStateNormal];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.btn setTitle:@"复制收款地址" forState:UIControlStateNormal];
//
//    });
}
@end
