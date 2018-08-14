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
@property (nonatomic, assign) ApexWalletType walletGlobleType; /**<  */
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
    
    _walletGlobleType = ((NSNumber*)[TKFileManager ValueWithKey:KglobleWalletType]).integerValue;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - ------delegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.typeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexMoreWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSNumber *type = self.typeArr[indexPath.row];
    if (type.integerValue == ApexWalletType_Neo) {
        cell.nameLable.text = @"NEO";
        cell.headerView.image = NEOPlaceHolder;
    }else if (type.integerValue == ApexWalletType_Eth){
        cell.nameLable.text = @"ETH";
        cell.headerView.image = ETHPlaceHolder;
    }else{
        cell.nameLable.text = @"ERROR TYPE";
    }
    
    if (type.integerValue == _walletGlobleType) {
        cell.backgroundColor = [[UIColor colorWithHexString:@"#4C8EFA"] colorWithAlphaComponent:0.3];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexMoreWalletCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = !cell.selected;
    [self routeEventWithName:RouteNameEvent_TopWalletCellDidChooseWallet userInfo:@{@"type":self.typeArr[indexPath.row]}];
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
