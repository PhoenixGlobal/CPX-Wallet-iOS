//
//  ApexLanguageSettingController.m
//  Apex
//
//  Created by chinapex on 2018/7/13.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexLanguageSettingController.h"
#import "CYLTabBarController.h"
#import "ApexLanguageSettingCell.h"

@interface ApexLanguageSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) ApexLanguageSettingCell *zhCell;
@property (nonatomic, strong) ApexLanguageSettingCell *enCell;
@end

@implementation ApexLanguageSettingController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self setNav];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)initUI{
    _language = [TKFileManager ValueWithKey:KLanguageSetting];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:ApexLanguageSettingCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [ApexUIHelper grayColor240];
    self.view.backgroundColor = [ApexUIHelper grayColor240];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    @weakify(self);
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [SOLocalization sharedLocalization].region = self.language;
        [TKFileManager saveValue:self.language forKey:KLanguageSetting];
        
        [self showHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideHUD];
            CYLTabBarController *tabbarVC = [[CYLTabBarController alloc] init];
            tabbarVC.initSelectTabbarBtnIndex = 0;
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbarVC;
        });
    }];
}

- (void)setNav{
    UIImage *image = [UIImage imageNamed:@"back-4"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    
    self.navigationItem.titleView = self.titleL;
}
#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexLanguageSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"简体中文";
        _zhCell = cell;
        [cell addLinecolor:[ApexUIHelper grayColor240] edge:UIEdgeInsetsMake(-1, 15, 0, 0)];
        [[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationSimplifiedChinese] ? (cell.imageV.hidden = NO) : (cell.imageV.hidden = YES);
    }else{
        cell.textLabel.text = @"English(U.S)";
        _enCell = cell;
        [[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish] ? (cell.imageV.hidden = NO) : (cell.imageV.hidden = YES);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        _language = SOLocalizationSimplifiedChinese;
        _zhCell.imageV.hidden = NO;
        _enCell.imageV.hidden = YES;
        
    }else{
        _language = SOLocalizationEnglish;
        _zhCell.imageV.hidden = YES;
        _enCell.imageV.hidden = NO;
    }
}
#pragma mark - ------eventResponse------

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ------getter & setter------
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_saveBtn setTitle:SOLocalizedStringFromTable(@"Save", nil) forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _saveBtn;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = SOLocalizedStringFromTable(@"LanguageSetting", nil);
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}
@end
