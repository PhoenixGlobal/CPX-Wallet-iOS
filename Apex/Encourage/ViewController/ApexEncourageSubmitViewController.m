//
//  ApexEncourageSubmitViewController.m
//  Apex
//
//  Created by 冯志勇 on 2018/8/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexEncourageSubmitViewController.h"
#import "ApexEncourageSubmitCell.h"

@interface ApexEncourageSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *navBackGroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *rightsReserveLabel;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation ApexEncourageSubmitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self handleEvent];
}

- (void)initUI
{
    self.title = @"APEX 第二波KRATOS One节点奖励";
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
}

#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self submitClock:nil];
    }];
}

- (void)submitClock:(id)sender
{
    ApexEncourageSubmitCell *cpxCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ApexEncourageSubmitCell *ethCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSLog(@"%@-%@", cpxCell.inputTextField.text, ethCell.inputTextField.text);
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
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    
    if (section == 1) {
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Page 1-3"]];
        [footerView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView).with.offset(30.0f);
            make.top.equalTo(footerView).with.offset(27.0f);
            make.size.mas_equalTo(CGSizeMake(13.0f, 13.0f));
        }];
        
        UILabel *activityDescribeLabel = [[UILabel alloc] init];
        activityDescribeLabel.font = [UIFont systemFontOfSize:13];
        activityDescribeLabel.numberOfLines = 0;
        activityDescribeLabel.text = SOLocalizedStringFromTable(@"Plese be sure you have local NEO wallet, and the total amount of CPX should be equal or more than 100.", nil);
        activityDescribeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [footerView addSubview:activityDescribeLabel];
        [activityDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(25.0f, 50.0f, 15.0f, 40.0f));
        }];
    }
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return [ApexUIHelper calculateTextHeight:[UIFont systemFontOfSize:13] givenText:SOLocalizedStringFromTable(@"Plese be sure you have local NEO wallet, and the total amount of CPX should be equal or more than 100.", nil) givenWidth:SCREEN_WIDTH - 90.0f] + 40.0f;
    }
    
    return 15.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApexEncourageSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark ------ setter
- (UIImageView *)navBackGroundView
{
    if (!_navBackGroundView) {
        _navBackGroundView = [[UIImageView alloc] init];
        _navBackGroundView.image = [UIImage imageNamed:@"encourageNav"];
    }
    
    return _navBackGroundView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [ApexUIHelper grayColor240];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
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
        _submitBtn.backgroundColor = [ApexUIHelper mainThemeColor];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
