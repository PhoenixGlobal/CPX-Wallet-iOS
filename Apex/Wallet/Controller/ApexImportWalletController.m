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

@interface ApexImportWalletController ()
@property (nonatomic, strong) ApexImportSwithHeaderBar *switchHeader;
@property (nonatomic, strong) ApexImportByKeystoreView *keyStoreView;
@property (nonatomic, strong) ApexImportByMnemonicView *mnemonicView;
@property (nonatomic, strong) UIImageView *backIV;
@end

@implementation ApexImportWalletController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - ------private------
- (void)initUI{
    self.title = SOLocalizedStringFromTable(@"Import Wallet", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    
    self.mnemonicView.didFinishImportSub = self.didFinishImportSub;
    self.keyStoreView.didFinishImportSub = self.didFinishImportSub;
    
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.switchHeader];
    [self.view addSubview:self.keyStoreView];
    [self.view addSubview:self.mnemonicView];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight+40);
    }];
    
    [self.switchHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backIV);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.mnemonicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIV.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.keyStoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mnemonicView);
    }];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

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
- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] init];
        _backIV.image = [UIImage imageNamed:@"Background"];
    }
    return _backIV;
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
