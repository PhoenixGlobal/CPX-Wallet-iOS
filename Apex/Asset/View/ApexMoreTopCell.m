//
//  ApexMoreTopCell.m
//  Apex
//
//  Created by chinapex on 2018/6/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexMoreTopCell.h"

@interface ApexMoreWalletCell :UITableViewCell
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLable;
@end

@implementation ApexMoreWalletCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

#pragma mark - ------private------
- (void)initUI{
    _headerView = [[UIImageView alloc] init];
    _headerView.image = [UIImage imageNamed:@"wallet-7"];
//    _headerView.hidden = YES;
    
    _nameLable = [[UILabel alloc] init];
    _nameLable.textColor = [UIColor colorWithHexString:@"666666"];
    _nameLable.font = [UIFont systemFontOfSize:17];
    
    [self.contentView addSubview:_headerView];
    [self.contentView addSubview:_nameLable];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.width.mas_equalTo(self.headerView.mas_height);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ApexMoreTopCell()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ApexMoreTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

#pragma mark - ------private------
- (void)initUI{
    [self.contentView addSubview:self.tableView];
    [self.tableView registerClass:[ApexMoreWalletCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - ------delegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.walletArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexMoreWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ApexWalletModel *model = self.walletArr[indexPath.row];
    cell.nameLable.text = [model.name capitalizedString];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexMoreWalletCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = !cell.selected;
    [self routeEventWithName:RouteNameEvent_TopWalletCellDidChooseWallet userInfo:@{@"wallet":self.walletArr[indexPath.row]}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - ------setter getter-----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
@end
