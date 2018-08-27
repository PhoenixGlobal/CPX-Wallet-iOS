//
//  ApexEncourageController.m
//  Apex
//
//  Created by yulin chi on 2018/8/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexEncourageController.h"
#import "ApexRewardListTableViewCell.h"
#import "ApexEncourageSubmitViewController.h"

@interface ApexEncourageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) UILabel *encourageLabel;
@property (nonatomic, strong) UIImageView *apexImageView;

@end

@implementation ApexEncourageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNav];
//    [self.tableView reloadData];
}


- (void)initUI
{
    self.view.backgroundColor = [ApexUIHelper grayColor240];
    [self.view insertSubview:self.backgroundImageView atIndex:0];
    self.title = SOLocalizedStringFromTable(@"Reward", nil);
//    self.title = SOLocalizedStringFromTable(@"", nil);
//    [self.view addSubview:self.backgroundImageView];
//    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.mas_equalTo(scaleHeight667(150));
//    }];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backgroundImageView.mas_bottom);
//        make.left.equalTo(self.view).with.offset(15.0f);
//        make.right.equalTo(self.view).with.offset(-15.0f);
//        make.bottom.equalTo(self.view);
//    }];
    
    [self.tableView registerClass:[ApexRewardListTableViewCell class] forCellReuseIdentifier:@"cell"];
    
//    [self.view addSubview:self.apexImageView];
    [self.accessoryBaseView addSubview:self.encourageLabel];

//    [self.apexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];

    [self.encourageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.accessoryBaseView);
        make.size.mas_equalTo(CGSizeMake(100.0f, 20.0f));
    }];
}


- (void)setNav
{
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
}


#pragma mark ------ UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasArray.count > indexPath.section) {
        return [ApexRewardListTableViewCell getContentHeightWithDictionary:self.datasArray[indexPath.section]];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApexRewardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.datasArray.count > indexPath.section) {
        [cell updaetRewardWithDictionary:self.datasArray[indexPath.section]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApexEncourageSubmitViewController *submitViewController = [[ApexEncourageSubmitViewController alloc] init];
    submitViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:submitViewController animated:YES];
}


#pragma mark ------Setter
- (NSMutableArray *)datasArray
{
    if (!_datasArray) {
        _datasArray = [NSMutableArray new];
        [_datasArray addObjectsFromArray:@[
                                           @{@"image":@"1",@"label":@"激励活动火热进行中",@"status":@"0", @"new":@"1"},
                                           @{@"image":@"0",@"label":@"The Second Wave of Our KRATOS One Special Node Program",@"status":@"1", @"new":@"1"},
                                           @{@"image":@"0",@"label":@"The Second Wave of Our KRATOS One Special Node Program",@"status":@"2", @"new":@"0"}
                                           ]];
    }
    
    return _datasArray;
}


- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"barImage"];
    }
    
    return _backgroundImageView;
}


//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.backgroundColor = [ApexUIHelper grayColor240];
//    }
//
//    return _tableView;
//}

- (UILabel *)encourageLabel
{
    if (!_encourageLabel) {
        _encourageLabel = [[UILabel alloc] init];
        _encourageLabel.font = [UIFont systemFontOfSize:18];
        _encourageLabel.textColor = [UIColor whiteColor];
        _encourageLabel.text = SOLocalizedStringFromTable(@"Reward", nil);
    }
    
    return _encourageLabel;
}

- (UIImageView *)apexImageView
{
    if (!_apexImageView) {
        _apexImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apexTitle"]];
    }
    
    return _apexImageView;
}

@end
