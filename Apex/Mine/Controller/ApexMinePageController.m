//
//  ApexMinePageController.m
//  Apex
//
//  Created by chinapex on 2018/7/12.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexMinePageController.h"
#import "ApexWalletManageController.h"
#import "ApexTransferHistoryController.h"
#import "ApexLanguageSettingController.h"
#import "ApexProfileBaseController.h"

@interface ApexMinePageController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *backIV;
@property (nonatomic, strong) ZJNButton *manageBtn;
@property (nonatomic, strong) ZJNButton *transDetailBtn;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ApexMinePageController
#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
}

#pragma mark - ------private------
- (void)initUI{
    self.title = SOLocalizedStringFromTable(@"Mine", nil);
    [self.view addSubview:self.backIV];
    [self.view addSubview:self.manageBtn];
    [self.view addSubview:self.transDetailBtn];
    [self.view addSubview:self.tableView];
    
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(scaleHeight667(150));
    }];
    
    [self.manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.backIV).offset(-25);
        make.width.mas_equalTo((kScreenW-30)/2.0);
        make.height.mas_equalTo(40);
    }];
    
    [self.transDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.backIV).offset(-25);
        make.width.mas_equalTo((kScreenW-30)/2.0);
        make.height.mas_equalTo(40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backIV.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setNav{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
}
#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"人物-名片-1"];
        cell.textLabel.text = SOLocalizedStringFromTable(@"Profile", nil);
    }else if (indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"地球"];
        cell.textLabel.text = SOLocalizedStringFromTable(@"Language", nil);
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"info (1)-1"];
        cell.textLabel.text = SOLocalizedStringFromTable(@"About Us", nil);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    v.backgroundColor = self.view.backgroundColor;
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    v.backgroundColor = self.view.backgroundColor;
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ApexProfileBaseController *basevc = [[ApexProfileBaseController alloc] init];
        basevc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:basevc animated:YES];
    }else if (indexPath.section == 1){
        ApexLanguageSettingController *settingVC = [[ApexLanguageSettingController alloc] init];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }else{
        
    }
    
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.manageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApexWalletManageController *vc = [[ApexWalletManageController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.transDetailBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ApexTransferHistoryController *vc = [[ApexTransferHistoryController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - ------getter & setter------
- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] init];
        _backIV.image = [UIImage imageNamed:@"barImage"];
    }
    return _backIV;
}

- (ZJNButton *)manageBtn{
    if (!_manageBtn) {
        _manageBtn = [[ZJNButton alloc] init];
        [_manageBtn setImage:[UIImage imageNamed:@"钱包-1"] forState:UIControlStateNormal];
        [_manageBtn setTitle:SOLocalizedStringFromTable(@"Manage Wallet", nil) forState:UIControlStateNormal];
        _manageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _manageBtn.contentMode = UIViewContentModeScaleAspectFit;
        _manageBtn.imagePosition = ZJNButtonImagePosition_Left;
        _manageBtn.spacingBetweenImageAndTitle = 10;
        [_manageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _manageBtn.backgroundColor = [UIColor clearColor];
    }
    return _manageBtn;
}

- (ZJNButton *)transDetailBtn{
    if (!_transDetailBtn) {
        _transDetailBtn = [[ZJNButton alloc] init];
        [_transDetailBtn setImage:[UIImage imageNamed:@"_历史小"] forState:UIControlStateNormal];
        [_transDetailBtn setTitle:SOLocalizedStringFromTable(@"Transaction Records", nil) forState:UIControlStateNormal];
        _transDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _transDetailBtn.contentMode = UIViewContentModeScaleAspectFit;
        _transDetailBtn.imagePosition = ZJNButtonImagePosition_Left;
        _transDetailBtn.spacingBetweenImageAndTitle = 10;
        [_transDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _transDetailBtn.backgroundColor = [UIColor clearColor];
    }
    return _transDetailBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [ApexUIHelper grayColor240];
    }
    return _tableView;
}
@end
