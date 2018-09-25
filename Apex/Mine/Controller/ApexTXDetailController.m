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
@property (weak, nonatomic) IBOutlet UILabel *gas;
@property (weak, nonatomic) IBOutlet UILabel *gasPriceL;
@property (weak, nonatomic) IBOutlet UILabel *gasFee;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopConstrant;



//@property (weak, nonatomic) IBOutlet UILabel *blockHeight;
@property (weak, nonatomic) IBOutlet UILabel *tipL0;
@property (weak, nonatomic) IBOutlet UILabel *tipL1;
@property (weak, nonatomic) IBOutlet UILabel *tipL2;
@property (weak, nonatomic) IBOutlet UILabel *tipL3;
@property (weak, nonatomic) IBOutlet UILabel *tipL4;
@property (weak, nonatomic) IBOutlet UILabel *tipL5;
@property (weak, nonatomic) IBOutlet UILabel *tipL6;


@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UILabel *titleLable;
@end

@implementation ApexTXDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self setNav];
    
    [self eventHandler];
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
    
    if (_model.status == ApexTransferStatus_Confirmed) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.time.doubleValue];
        _timeStamp.text = [NSString stringWithFormat:@"%ld-%ld-%ld %02ld:%02ld:%02ld",(long)date.year,date.month,date.day, date.hour, date.minute,date.second];
    }
    
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
    
    _gas.text = _model.gas_consumed != nil ? _model.gas_consumed : @"0";
    _gasPriceL.text = _model.gas_price != nil ? [NSString DecimalFuncWithOperatorType:3 first:_model.gas_price secend:@"1000000000" value:0] : @"0";
    _gasFee.text = _model.gas_fee != nil ? _model.gas_fee : @"0";
    
    _tipL0.text = SOLocalizedStringFromTable(@"From", nil);
    _tipL1.text = SOLocalizedStringFromTable(@"To", nil);
    _tipL2.text = SOLocalizedStringFromTable(@"Time", nil);
    _tipL3.text = SOLocalizedStringFromTable(@"Txid", nil);
    _tipL4.text = SOLocalizedStringFromTable(@"gas", nil);
    _tipL5.text = SOLocalizedStringFromTable(@"gasPrice", nil);
    _tipL6.text = SOLocalizedStringFromTable(@"gasFee", nil);
    
    _lineTopConstrant.constant = 15;
    _tipL4.hidden = YES;
    _tipL5.hidden = YES;
    _tipL6.hidden = YES;
    _gas.hidden = YES;
    _gasPriceL.hidden = YES;
    _gasFee.hidden = YES;
    
    if ([_model.type isEqualToString:EthType] || [_model.type isEqualToString:Erc20Type]) {
        _tipL4.hidden = NO;
        _tipL5.hidden = NO;
        _tipL6.hidden = NO;
        _gas.hidden = NO;
        _gasPriceL.hidden = NO;
        _gasFee.hidden = NO;
        _lineTopConstrant.constant = 190;
    }
}

#pragma mark - eventResponse
- (void)eventHandler{
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
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.text = SOLocalizedStringFromTable(@"Transaction Detail", nil);
    }
    return _titleLable;
}
@end
