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
@property (weak, nonatomic) IBOutlet UILabel *tipL0;
@property (weak, nonatomic) IBOutlet UILabel *tipL1;
@property (weak, nonatomic) IBOutlet UILabel *tipL2;
@property (weak, nonatomic) IBOutlet UILabel *tipL3;

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
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.time.doubleValue];
    _timeStamp.text = [NSString stringWithFormat:@"%ld-%ld-%ld %02ld:%02ld:%02ld",(long)date.year,date.month,date.day, date.hour, date.minute,date.second];
    
    _fromAddressL.text = self.model.from;
    _toAddressL.text = self.model.to;
    _txic.text = self.model.txid;
    _valueL.text = self.model.value;
    
    if (self.model.symbol) {
        
        if ([self.model.assetId isEqualToString:assetId_NeoGas]) {
            self.model.symbol = @"GAS";
        }
        
        _subTitleL.text = [NSString stringWithFormat:@"%@(%@)",SOLocalizedStringFromTable(@"Amount", nil),self.model.symbol];
    }else{
            _subTitleL.text = SOLocalizedStringFromTable(@"Amount", nil);
    }
    
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = self.txic.text;
        [self showMessage:SOLocalizedStringFromTable(@"Copied", nil)];
    }];
    _txic.userInteractionEnabled = YES;
    [_txic addGestureRecognizer:tap];
    
    _tipL0.text = SOLocalizedStringFromTable(@"From", nil);
    _tipL1.text = SOLocalizedStringFromTable(@"To", nil);
    _tipL2.text = SOLocalizedStringFromTable(@"Time", nil);
    _tipL3.text = SOLocalizedStringFromTable(@"Txid", nil);
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
        _titleLable.text = SOLocalizedStringFromTable(@"Transaction Detail", nil);
    }
    return _titleLable;
}
@end
