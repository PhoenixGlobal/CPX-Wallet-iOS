//
//  ApexSendMoneyController.m
//  Apex
//
//  Created by chinapex on 2018/5/21.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexSendMoneyController.h"
#import "ApexTXIDModel.h"
#import "ApexTXRecorderModel.h"
#import "ApexSendMoneyViewModel.h"
#import "LXDScanCodeController.h"
#import "ApexPassWordConfirmAlertView.h"
#import "ApexTransferModel.h"
#import "ApexTransferHistoryManager.h"
#import "ETHTransferHistoryManager.h"

@interface ApexSendMoneyController ()<LXDScanCodeControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *walletNameL;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressL;
@property (weak, nonatomic) IBOutlet UITextField *sendNumTF;
@property (weak, nonatomic) IBOutlet UITextField *toAddressTF;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) UIButton *scanBtn;
@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) ApexSendMoneyViewModel *viewModel;
@property (nonatomic, strong) NSNumber *confirmBlock;
@property (nonatomic, strong) ApexTXIDModel *txidModel;
@property (nonatomic, strong) NeomobileWallet *wallet;
@property (nonatomic, strong) UIButton *backBtn;


@property (nonatomic, strong) id<ApexTransHistoryProtocal> historyManager; /**<  */

@property (weak, nonatomic) IBOutlet UILabel *availableL;
@property (weak, nonatomic) IBOutlet UIButton *takeAllBtn;

//eth
@property (weak, nonatomic) IBOutlet UIView *ethPanelView;
@property (weak, nonatomic) IBOutlet UISlider *gasSlider;
@property (weak, nonatomic) IBOutlet UILabel *gasPriceL;
@property (weak, nonatomic) IBOutlet UILabel *slowL;
@property (weak, nonatomic) IBOutlet UILabel *fastL;
@property (weak, nonatomic) IBOutlet UILabel *currentGasPriceL;
@property (weak, nonatomic) IBOutlet UILabel *currentGasPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalETHL;
@property (weak, nonatomic) IBOutlet UILabel *TotalEthTitle;


@end

@implementation ApexSendMoneyController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self request];
    
    [self handleEvent];
    
    [self setNav];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - ------private------
- (void)setNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setUI{
    
    self.navigationItem.titleView = self.titleLable;
    self.walletNameL.text = self.walletName;
    self.fromAddressL.text = self.walletAddress;
    self.toAddressTF.text = self.toAddressIfHave;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanBtn];
    
    [ApexUIHelper addLineInView:self.sendNumTF color:[ApexUIHelper grayColor] edge:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    self.sendBtn.layer.cornerRadius = 6;
    self.unitL.text = [self.balanceModel getRelativeNeoAssetModel].symbol;
    
    self.currentGasPriceTitle.text = SOLocalizedStringFromTable(@"currentGasPrice", nil);
    self.TotalEthTitle.text = SOLocalizedStringFromTable(@"Total", nil);
    self.slowL.text = SOLocalizedStringFromTable(@"slow", nil);
    self.fastL.text = SOLocalizedStringFromTable(@"fast", nil);
    self.toAddressTF.placeholder = SOLocalizedStringFromTable(@"SendMoneyAddress", nil);
    self.sendNumTF.placeholder = SOLocalizedStringFromTable(@"Amount", nil);
    [self.sendBtn setTitle:SOLocalizedStringFromTable(@"send", nil) forState:UIControlStateNormal];
    
    NSMutableAttributedString *attrStr = nil;
    NSString *string = @"";
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        string = [NSString stringWithFormat:@"Amount (Available: %@)",self.balanceModel.value];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }else{
        string = [NSString stringWithFormat:@"交易金额 (可用数量: %@)",self.balanceModel.value];
        attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    }
    
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([string rangeOfString:@":"].location+2, self.balanceModel.value.length)];
    self.availableL.attributedText = attrStr;
    
    [self.takeAllBtn setTitle:SOLocalizedStringFromTable(@"allMoney", nil) forState:UIControlStateNormal];
    
//    //计算gas费用
//    NSString *minValue = [NSString DecimalFuncWithOperatorType:2 first:@"25200000000000" secend:[_balanceModel.asset isEqualToString:assetId_Eth] ? @"90000" : _balanceModel.gas value:8];
//    minValue = [NSString DecimalFuncWithOperatorType:3 first:minValue secend:@"21000" value:8];
//    minValue = [NSString DecimalFuncWithOperatorType:3 first:minValue secend:@"1000000000000000000" value:8];
//
//    NSString *maxValue = [NSString DecimalFuncWithOperatorType:2 first:@"2520120000000000" secend:[_balanceModel.asset isEqualToString:assetId_Eth] ? @"90000" : _balanceModel.gas value:8];
//    maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"21000"  value:8];
//    maxValue = [NSString DecimalFuncWithOperatorType:3 first:maxValue secend:@"1000000000000000000" value:8];
    
    self.gasSlider.minimumValue = 1;
    self.gasSlider.maximumValue = 32;
    self.gasSlider.value = 0;
    
    [self.viewModel updateEthValue];

    //区分类型
    if ([_walletManager isKindOfClass:ETHWalletManager.class]) {
        self.historyManager = [ETHTransferHistoryManager shareManager];
        _ethPanelView.hidden = NO;
        
    }else{
        self.historyManager = [ApexTransferHistoryManager shareManager];
        _ethPanelView.hidden = YES;
    }
    self.viewModel.historyManager = _historyManager;
    
}

- (void)request{
    @weakify(self);
    [self.viewModel getCurrentGasPrice:^(NSString *gasPriceInGWei) {
        @strongify(self);
        self.currentGasPriceL.text = [NSString stringWithFormat:@"%.2f", gasPriceInGWei.floatValue];
        self.gasSlider.minimumValue = [NSString stringWithFormat:@"%.2f",gasPriceInGWei.floatValue].floatValue;
        self.gasSlider.maximumValue = self.gasSlider.minimumValue + 32;
        self.gasSlider.value = self.gasSlider.minimumValue * 2;
        self.viewModel.gasSliderValue = @(self.gasSlider.value).stringValue;
        [self sliderValueChanged:self.gasSlider];
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (void)scanCodeController:(LXDScanCodeController *)scanCodeController codeInfo:(NSString *)codeInfo{

    NSString *toaddress = codeInfo;
    self.toAddressTF.text = toaddress;
}


#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        LXDScanCodeController *scanvc = [[LXDScanCodeController alloc] init];
        scanvc.scanDelegate = self;
        [self.navigationController pushViewController:scanvc animated:YES];
    }];
    
    [[self.takeAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.sendNumTF.text = self.balanceModel.value;
    }];
}

- (IBAction)sliderValueChanged:(id)sender {
    self.gasPriceL.text = [NSString stringWithFormat:@"%.2lf Gwei", _gasSlider.value];
    NSString *total = [NSString DecimalFuncWithOperatorType:2 first:@(_gasSlider.value).stringValue secend:@"90000" value:0];
    total = [NSString DecimalFuncWithOperatorType:3 first:total secend:@"1000000000" value:0];
    self.totalETHL.text = [NSString stringWithFormat:@"%.11f",total.floatValue];
    self.viewModel.gasSliderValue = @(self.gasSlider.value).stringValue;
}

- (IBAction)amountChanged:(id)sender {
    NSString *num = _sendNumTF.text;
    
    if ([num containsString:@"."]) {
        NSString *interger = [num componentsSeparatedByString:@"."].firstObject;
        NSString *decimal = [num componentsSeparatedByString:@"."].lastObject;
        if (decimal.length >= 8) {
            decimal = [decimal substringToIndex:8];
        }
        _sendNumTF.text = [NSString stringWithFormat:@"%@.%@",interger,decimal];
    }
}



- (IBAction)sendAction:(id)sender {
    
    
    if ([self.walletManager isKindOfClass:ETHWalletManager.class]) {
        //判断gas
        if(self.viewModel.currentEthNumber.floatValue < self.totalETHL.text.floatValue){
            [self showMessage:SOLocalizedStringFromTable(@"insufficentGas", nil)];
            return;
        }
        //eth地址有效性判断
        if (![NSString isAdress:_toAddressTF.text]) {
            [self showMessage:SOLocalizedStringFromTable(@"Please enter the correct wallet address", nil)];
            return;
        }
        
    }else{
        //neo地址有效性判断
        NSString *decode = NeomobileDecodeAddress(_toAddressTF.text, nil);
        if (decode == nil){
            [self showMessage:SOLocalizedStringFromTable(@"Please enter the correct wallet address", nil)];
            return;
        }
    }
    
    if (![NSString isMoneyNumber:_sendNumTF.text] || _sendNumTF.text.floatValue == 0) {
        [self showMessage:SOLocalizedStringFromTable(@"InvalidateMoney", nil)];
    }else if (_sendNumTF.text.floatValue > _balanceModel.value.floatValue) {
        [self showMessage:SOLocalizedStringFromTable(@"BalanceNotEnough", nil)];
    }else if ([_toAddressTF.text isEqualToString:_walletAddress]){
        [self showMessage:SOLocalizedStringFromTable(@"InvalidateAddress", nil)];
    }else if ([_toAddressTF.text isEqualToString:@""]) {
        [self showMessage:SOLocalizedStringFromTable(@"Please enter the correct wallet address", nil)];
    }else{
        //输入密码
        [ApexPassWordConfirmAlertView showEntryPasswordAlertAddress:_walletAddress walletManager:self.walletManager subTitle:@"" Success:^(id wallet) {
            
            self.viewModel.toAddress = self.toAddressTF.text;
            self.viewModel.amount = [self.sendNumTF.text isEqualToString:@""] ? @"0" : self.sendNumTF.text;
            
            if ([self.walletManager isKindOfClass:ETHWalletManager.class]) {
                [self.viewModel ethTransactionWithWallet:wallet];
            }else{
                [self.viewModel neoTransactionWithWallet:wallet];
            }
            
        } fail:^{
            [self showMessage:SOLocalizedStringFromTable(@"Password Error", nil)];
        }];
    }
}

#pragma mark - ------getter & setter------
- (ApexSendMoneyViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ApexSendMoneyViewModel alloc] init];
        _viewModel.address = self.walletAddress;
        _viewModel.ownerVC = self;
        _viewModel.balanceModel = self.balanceModel;
        _viewModel.currentEthNumber = @"0";
    }
    return _viewModel;
}

- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_scanBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
    }
    return _scanBtn;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = SOLocalizedStringFromTable(@"Transfer", nil);
    }
    return _titleLable;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 20, 30)];
        [_backBtn setImage:[UIImage imageNamed:@"back-4"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

@end
