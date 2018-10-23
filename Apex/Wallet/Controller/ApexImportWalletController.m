//
//  ApexImportWalletController.m
//  Apex
//
//  Created by chinapex on 2018/5/7.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexImportWalletController.h"
#import "ApexImportSwithHeaderBar.h"
#import "ApexImportByKeystoreView.h"
#import "ApexImportByMnemonicView.h"
#import "ApexPageView.h"


@interface ApexImportWalletController ()<ApexPageViewDelegate>
@property (nonatomic, strong) ApexImportSwithHeaderBar *switchHeader;
@property (nonatomic, strong) ApexImportByKeystoreView *keyStoreView;
@property (nonatomic, strong) ApexImportByMnemonicView *mnemonicView;
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) ApexPageView *pageView; /**<  */
@end

@implementation ApexImportWalletController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setnav];
    [self initUI];
}

#pragma mark - ------private------
- (void)initUI{
    
    self.mnemonicView.didFinishImportSub = self.didFinishImportSub;
    self.keyStoreView.didFinishImportSub = self.didFinishImportSub;
    
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.backIV];
//    [self.view addSubview:self.switchHeader];
//    [self.view addSubview:self.keyStoreView];
//    [self.view addSubview:self.mnemonicView];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight+20);
    }];
    
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIV.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
//    [self.switchHeader mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.backIV);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(40);
//    }];
//
//    [self.mnemonicView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backIV.mas_bottom);
//        make.left.right.bottom.equalTo(self.view);
//    }];
//
//    [self.keyStoreView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.mnemonicView);
//    }];
}

- (void)setnav
{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-4"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.titleView = self.titleL;
}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfPageInPageView{
    return 2;
}

- (UIView *)pageView:(ApexPageView *)pageView viewForPageAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.mnemonicView;
    }else{
        return self.keyStoreView;
    }
}

- (NSString *)pageView:(ApexPageView *)pageView titleForPageAtIndex:(NSInteger)index{
    if (index == 0) {
        return SOLocalizedStringFromTable(@"Mnemonics",nil);
    }else{
        return @"keystore";
    }
}

#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_ImportWalletByKeystore]) {
        self.keyStoreView.hidden = NO;
        self.mnemonicView.hidden = YES;
    }else if ([eventName isEqualToString:RouteNameEvent_ImportWalletByMnemonic]){
        self.keyStoreView.hidden = YES;
        self.mnemonicView.hidden = NO;
    }
}

#pragma mark - ------getter & setter------
- (ApexPageView *)pageView{
    if (!_pageView) {
        _pageView = [[ApexPageView alloc] init];
        _pageView.delegate = self;
    }
    return _pageView;
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] init];
        _backIV.image = [UIImage imageNamed:@"Background"];
    }
    return _backIV;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.frame = CGRectMake(152, 30, 72.5, 25);
        _titleL.text = SOLocalizedStringFromTable(@"Import Wallet", nil);
        _titleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _titleL.textColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
    }
    return _titleL;
}

- (ApexImportSwithHeaderBar *)switchHeader{
    if (!_switchHeader) {
        _switchHeader = [[ApexImportSwithHeaderBar alloc] init];
    }
    return _switchHeader;
}

- (ApexImportByKeystoreView *)keyStoreView{
    if (!_keyStoreView) {
        _keyStoreView = [[ApexImportByKeystoreView alloc] init];
    }
    return _keyStoreView;
}

- (ApexImportByMnemonicView *)mnemonicView{
    if (!_mnemonicView) {
        _mnemonicView = [[ApexImportByMnemonicView alloc] init];
    }
    return _mnemonicView;
}
@end
