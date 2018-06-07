//
//  ApexExportKeystoryFileView.h
//  Apex
//
//  Created by chinapex on 2018/6/7.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexExportKeystoryFileView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *ksBtn;

@property (nonatomic, strong) NSString *address;
@end
