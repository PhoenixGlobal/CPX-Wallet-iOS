//
//  ApexEncourageSubmitViewController.m
//  Apex
//
//  Created by 冯志勇 on 2018/8/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexEncourageSubmitViewController.h"
#import "ApexEncourageSubmitCell.h"
#import "ApexEncourageSubmitFooterView.h"

@interface ApexEncourageSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *navBackGroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *rightsReserveLabel;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) RACSignal *combineSignal;

@end

@implementation ApexEncourageSubmitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self handleEvent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self judgeCanInputWithLimit:@(self.currentCpx)];
}


- (void)initUI
{
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        self.title = _activityModel.title_en;
    }
    else {
        self.title = _activityModel.title_cn;
    }
    
    self.view.backgroundColor = [ApexUIHelper grayColor240];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navBackGroundView];
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.rightsReserveLabel];
    
    [self.navBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(NavBarHeight);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    [self.rightsReserveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.right.equalTo(self.view).offset(-15.0f);
        make.bottom.equalTo(self.submitBtn.mas_top).offset(-5.0f);
        make.height.mas_equalTo(35.0f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.rightsReserveLabel.mas_top).offset(-10);
    }];
    
    [self.tableView registerClass:[ApexEncourageSubmitCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[ApexEncourageSubmitFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    
    [self setSubmitButtonStatus:NO];
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self submitClock];
    }];
}

- (void)submitClock
{
    NSString *cpxAddress = [self getInputCpxString];
    NSString *ethAddress = [self getInputEthString];
    
    [CYLNetWorkManager POST:@"j2/activitys/save/" parameter:@{@"CPX":cpxAddress, @"ETH":ethAddress, @"id":_activityModel.activityId} success:^(CYLResponse *response) {
        
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:response.returnObj options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *statusDictionary = resultDictionary[@"data"];
        NSString *status = [NSString stringWithFormat:@"%@", [statusDictionary objectForKey:@"CPX"]];
        
        if ([status isEqualToString:@"5200"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self showMessageOnWindow:SOLocalizedStringFromTable(@"Submitted successfully", nil)];
        }
        else if ([status isEqualToString:@"5000"]) {
            [self showAlertViewControllerWithString:SOLocalizedStringFromTable(@"This address has already participated\nplease do not submit again", nil) isPop:NO];
        }
        else if ([status isEqualToString:@"5003"]) {
            [self showAlertViewControllerWithString:SOLocalizedStringFromTable(@"_Please enter the correct wallet address", nil) isPop:NO];
        }
        else if ([status isEqualToString:@"5001"]) {
            [self showAlertViewControllerWithString:SOLocalizedStringFromTable(@"Server error, storage failed", nil) isPop:NO];
        }
        
    } fail:^(NSError *error) {
        [self showMessage:SOLocalizedStringFromTable(@"Server request failed", nil)];
    }];
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = @[SOLocalizedStringFromTable(@"CPX Address(achieves T1/Genesis level)", nil), SOLocalizedStringFromTable(@"ETH Address", nil)];
    return [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        ApexEncourageSubmitFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
        footerView.limitAccount = _activityModel.gas_limit;
        return footerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        NSString *limitAccount = @"";
        if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
            limitAccount = [NSString stringWithFormat:@"%@%@", @"Please be sure you have local NEO wallet, and the total amount of CPX should be equal or more than ", _activityModel.gas_limit];
        }
        else {
            limitAccount = [NSString stringWithFormat:@"参与活动需在本地创建NEO钱包，并且钱包中的CPX总余额大于等于%@(≥%@)方可参加。", _activityModel.gas_limit, _activityModel.gas_limit];
        }
        return [ApexUIHelper calculateTextHeight:[UIFont systemFontOfSize:13] givenText:limitAccount givenWidth:SCREEN_WIDTH - 90.0f] + 40.0f;
    }
    
    return 15.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApexEncourageSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        [cell.inputTextField addTarget:self action:@selector(inputCpxDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    else if (indexPath.section == 1) {
        [cell.inputTextField addTarget:self action:@selector(inputEthDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return cell;
}

- (NSString *)getInputCpxString
{
    ApexEncourageSubmitCell *cpxCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cpxCell.inputTextField.text;
}

- (NSString *)getInputEthString
{
    ApexEncourageSubmitCell *ethCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    return ethCell.inputTextField.text;
}

#pragma mark ------ UITextField
- (void)inputCpxDidChange:(ApexAlertTextField *)sender
{
    NSString *cpxAddress = sender.text;
    NSString *ethAddress = [self getInputEthString];
    
    [self setSubmitButtonStatus:(cpxAddress.length > 0 && ethAddress.length > 0)];
}

- (void)inputEthDidChange:(ApexAlertTextField *)sender
{
    NSString *cpxAddress = [self getInputCpxString];
    NSString *ethAddress = sender.text;
    
    [self setSubmitButtonStatus:(cpxAddress.length > 0 && ethAddress.length > 0)];
}

- (void)setSubmitButtonStatus:(BOOL)enable
{
    if (enable) {
        self.submitBtn.backgroundColor = [ApexUIHelper mainThemeColor];
        self.submitBtn.enabled = YES;
    }
    else {
        self.submitBtn.backgroundColor = [ApexUIHelper grayColor];
        self.submitBtn.enabled = NO;
    }
}

- (void)showAlertViewControllerWithString:(NSString *)alertString isPop:(BOOL)pop
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertString preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:SOLocalizedStringFromTable(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (pop) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)judgeCanInputWithLimit:(NSNumber *)userAccount
{
    double limitAccount = [_activityModel.gas_limit doubleValue];
    if ([userAccount doubleValue] < limitAccount) {
        [self showAlertViewControllerWithString:[NSString stringWithFormat:@"%@%@（≥%@）", SOLocalizedStringFromTable(@"Please be sure the amount of CPX in the local wallets more than", nil), _activityModel.gas_limit, _activityModel.gas_limit] isPop:YES];
    }
}

- (UIImageView *)navBackGroundView
{
    if (!_navBackGroundView) {
        _navBackGroundView = [[UIImageView alloc] init];
        _navBackGroundView.image = [UIImage imageNamed:@"encourageNav"];
    }
    
    return _navBackGroundView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [ApexUIHelper grayColor240];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 44.0f;
        _tableView.estimatedRowHeight = 50.0f;
        _tableView.estimatedSectionHeaderHeight = 50.0f;
        _tableView.estimatedSectionFooterHeight = 10.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UILabel *)rightsReserveLabel
{
    if (!_rightsReserveLabel) {
        _rightsReserveLabel = [[UILabel alloc] init];
        _rightsReserveLabel.numberOfLines = 2;
        _rightsReserveLabel.font = [UIFont systemFontOfSize:12];
        _rightsReserveLabel.text = SOLocalizedStringFromTable(@"The final interpretation of this activity belongs to\nAPEX TECHNOLOGIES", nil);
        _rightsReserveLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _rightsReserveLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _rightsReserveLabel;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.layer.cornerRadius = 6;
        _submitBtn.clipsToBounds = YES;
        [_submitBtn setTitle:SOLocalizedStringFromTable(@"_Confirm", nil) forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return _submitBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
