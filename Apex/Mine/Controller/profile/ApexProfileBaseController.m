//
//  ApexProfileBaseController.m
//  Apex
//
//  Created by yulin chi on 2018/7/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexProfileBaseController.h"
#import "ApexCommonProfileController.h"
#import "ApexSpecialProfileController.h"
#import "ApexPageView.h"
#import "ApexChangeBindWalletController.h"

@interface ApexProfileBaseController ()<ApexPageViewDelegate>
@property (nonatomic, strong) UIImageView *backIV; /**<  */
@property (nonatomic, strong) ApexPageView *pageView; /**<  */
@property (nonatomic, strong) UIButton *exchangeBtn; /**<  */
@property (nonatomic, strong) UILabel *currentAddress; /**<  */
@property (nonatomic, strong) ApexCommonProfileController *commonVC; /**<  */
@property (nonatomic, strong) ApexSpecialProfileController *specialVC; /**<  */
@end

@implementation ApexProfileBaseController
#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self setNav];
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    
    NSString *bindingAddress = [TKFileManager ValueWithKey:KBindingWalletAddress];
    if (bindingAddress == nil) {
        bindingAddress = ((ApexWalletModel*)((NSArray*)[ApexWalletManager getWalletsArr]).firstObject).address;
        [TKFileManager saveValue:bindingAddress forKey:KBindingWalletAddress];
    }
    self.currentAddress.text = bindingAddress;
}

#pragma mark - ------private------
- (void)initUI{
    self.title = SOLocalizedStringFromTable(@"Profile", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.currentAddress];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight+24);
    }];
    
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIV.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.currentAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backIV).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)setNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.exchangeBtn];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfPageInPageView{
    return 2;
}

- (UIView *)pageView:(ApexPageView *)pageView viewForPageAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.commonVC.view;
    }else{
        return self.specialVC.view;
    }
}

- (NSString *)pageView:(ApexPageView *)pageView titleForPageAtIndex:(NSInteger)index{
    if (index == 0) {
        return SOLocalizedStringFromTable(@"commProfile", nil);
    }else{
        return SOLocalizedStringFromTable(@"enterProfile", nil);
    }
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.exchangeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApexChangeBindWalletController *vc = [[ApexChangeBindWalletController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark - ------getter & setter------

- (ApexPageView *)pageView{
    if (!_pageView) {
        _pageView = [[ApexPageView alloc] init];
        _pageView.delegate = self;
    }
    return _pageView;
}

- (ApexCommonProfileController *)commonVC{
    if (!_commonVC) {
        _commonVC = [[ApexCommonProfileController alloc] init];
        _commonVC.baseController = self;
    }
    return _commonVC;
}

- (ApexSpecialProfileController *)specialVC{
    if (!_specialVC) {
        _specialVC = [[ApexSpecialProfileController alloc] init];
        _specialVC.baseController = self;
    }
    return _specialVC;
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barImage"]];
    }
    return _backIV;
}

- (UIButton *)exchangeBtn{
    if (!_exchangeBtn) {
        _exchangeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_exchangeBtn setImage:[UIImage imageNamed:@"Group 2-1"] forState:UIControlStateNormal];
    }
    return _exchangeBtn;
}

- (UILabel *)currentAddress{
    if (!_currentAddress) {
        _currentAddress = [[UILabel alloc] init];
        _currentAddress.font = [UIFont systemFontOfSize:14];
        _currentAddress.textColor = [UIColor whiteColor];
        _currentAddress.text = @"dfsfs";
    }
    return _currentAddress;
}
@end
