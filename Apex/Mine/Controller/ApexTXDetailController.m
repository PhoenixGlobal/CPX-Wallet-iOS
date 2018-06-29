//
//  ApexTXDetailController.m
//  Apex
//
//  Created by chinapex on 2018/6/19.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexTXDetailController.h"
#import "ApexTransferModel.h"
#import "ApexTransferHistoryManager.h"

@interface ApexTXDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *fromAddressL;
@property (weak, nonatomic) IBOutlet UILabel *toAddressL;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *txic;
@property (weak, nonatomic) IBOutlet UILabel *valueL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
//@property (weak, nonatomic) IBOutlet UILabel *blockHeight;

@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UILabel *titleLable;
@end

@implementation ApexTXDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self setNav];
}

- (void)setNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backIV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.backIV addGestureRecognizer:tap];
}

- (void)initUI{
    self.navigationItem.titleView = self.titleLable;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _timeStamp.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.model.time.integerValue]];
    
    _fromAddressL.text = self.model.from;
    _toAddressL.text = self.model.to;
    _txic.text = self.model.txid;
    _valueL.text = self.model.value;
    if (self.model.symbol) {
        _subTitleL.text = [NSString stringWithFormat:@"交易金额(%@)",self.model.symbol];
    }
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = self.txic.text;
        [self showMessage:@"txid已复制到剪切板"];
    }];
    _txic.userInteractionEnabled = YES;
    [_txic addGestureRecognizer:tap];
}

#pragma mark - ------getter-----
- (UIImageView *)backIV{
    if (!_backIV) {
        UIImage *image = [UIImage imageNamed:@"back-4"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _backIV = [[UIImageView alloc] initWithImage:image];
        _backIV.userInteractionEnabled = YES;
    }
    return _backIV;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.text = @"交易详情";
    }
    return _titleLable;
}
@end
