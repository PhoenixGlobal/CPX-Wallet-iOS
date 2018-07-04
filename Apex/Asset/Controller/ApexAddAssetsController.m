//
//  ApexAddAssetsController.m
//  Apex
//
//  Created by chinapex on 2018/7/4.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexAddAssetsController.h"
#import "ApexSearchWalletToolBar.h"
#import "ApexAddAssetsController.h"

@interface ApexAddAssetsController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ApexSearchWalletToolBar *searchToolBar;
@end

@implementation ApexAddAssetsController
#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self handleEvent];
}

#pragma mark - ------private------
- (void)setUI{
    self.title = @"添加资产";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.searchToolBar];
    [self.view addSubview:self.tableView];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(10);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.searchToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchToolBar.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}
#pragma mark - ------getter & setter------
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"Group 21"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (ApexSearchWalletToolBar *)searchToolBar{
    if (!_searchToolBar) {
        _searchToolBar = [[ApexSearchWalletToolBar alloc] init];
        _searchToolBar.placeHolder = @"资产id";
    }
    return _searchToolBar;
}
@end
