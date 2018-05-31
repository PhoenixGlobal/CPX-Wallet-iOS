//
//  ApexSwithWalletView.m
//  Apex
//
//  Created by chinapex on 2018/5/31.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSwithWalletView.h"

@interface ApexSwithWalletView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *baseView;
@end

@implementation ApexSwithWalletView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self handleEvent];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.cancleBtn];
    [self.baseView addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(scaleWidth375(275));
        make.height.mas_equalTo(scaleHeight667(450));
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.equalTo(self.cancleBtn.superview).offset(10);
        make.right.equalTo(self.cancleBtn.superview).offset(-10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tableView.superview);
        make.top.equalTo(self.cancleBtn.mas_bottom).offset(10);
    }];
}


- (void)handleEvent{
    [[self.cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self removeFromSuperview];
    }];
}

#pragma mark - delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ApexWalletModel *model = self.contentArr[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSwitchSub) {
        [self.didSwitchSub sendNext:self.contentArr[indexPath.row]];
    }
    [self removeFromSuperview];
}

#pragma mark - setter getter
- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc] init];
        [_cancleBtn setImage:[UIImage imageNamed:@"Group 21"] forState:UIControlStateNormal];
    }
    return _cancleBtn;
}

- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.cornerRadius = 6;
        _baseView.layer.masksToBounds = YES;
    }
    return _baseView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _tableView;
}
@end
