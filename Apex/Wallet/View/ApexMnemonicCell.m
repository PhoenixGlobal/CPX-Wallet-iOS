//
//  ApexMnemonicCell.m
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexMnemonicCell.h"
#import "UILabel+Spacing.h"

@interface ApexMnemonicCell()
@property (nonatomic, strong) UILabel *mnemonicL;
@end

@implementation ApexMnemonicCell
@synthesize selected = _selected;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    
    [self.contentView addSubview:self.mnemonicL];
    [self.mnemonicL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [self setChoose:self.choose];
}


- (void)setChoose:(BOOL)choose{
    _choose = choose;
    if (choose) {
        self.mnemonicL.textColor = [UIColor whiteColor];
        self.backgroundColor = [ApexUIHelper mainThemeColor];
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.mnemonicL.textColor = [ApexUIHelper mainThemeColor];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [ApexUIHelper mainThemeColor].CGColor;
    }
}

- (void)setMnemonicStr:(NSString *)mnemonicStr{
    _mnemonicStr = mnemonicStr;
    self.mnemonicL.text = mnemonicStr;
}

#pragma mark -  getter
- (UILabel *)mnemonicL{
    if (!_mnemonicL) {
        _mnemonicL = [[UILabel alloc] init];
        _mnemonicL.font = [UIFont systemFontOfSize:12];
        _mnemonicL.backgroundColor = [UIColor clearColor];
    }
    return _mnemonicL;
}

@end
