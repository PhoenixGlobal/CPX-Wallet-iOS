//
//  ApexChangeBindWalletController.m
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexChangeBindWalletController.h"
#import "ApexChangeWalletCell.h"

@interface ApexChangeBindWalletController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView; /**<  */
@property (nonatomic, strong) UILabel *titleL; /**<  */
@property (nonatomic, strong) NSMutableArray *contentArr; /**<  */
@property (nonatomic, copy) NSString *bindingAddress; /**<  */
@end

@implementation ApexChangeBindWalletController
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
#pragma mark - ------private------
- (void)initUI{
    self.bindingAddress = [TKFileManager ValueWithKey:KBindingWalletAddress];
    
    if (_shouldIncludETH) {
        self.contentArr = [[ApexWalletManager shareManager] getWalletsArr];
        [self.contentArr addObjectsFromArray:[[ETHWalletManager shareManager] getWalletsArr]];
    }else{
        self.contentArr = [[ApexWalletManager shareManager] getWalletsArr];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApexChangeWalletCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)setNav{
    UIImage *image = [UIImage imageNamed:@"back-4"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.titleView = self.titleL;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexChangeWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ApexWalletModel *model = self.contentArr[indexPath.row];
    cell.model = model;
    if (_transHistoryWalletModel) {
        if ([_transHistoryWalletModel.address isEqualToString:model.address]) {
            cell.indicator.hidden = NO;
        }else{
            cell.indicator.hidden = YES;
        }
    }else{
        if ([_bindingAddress isEqualToString:model.address]) {
            cell.indicator.hidden = NO;
        }else{
            cell.indicator.hidden = YES;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexWalletModel *model = self.contentArr[indexPath.row];
    if (self.didSelectCellSub) {
        [self.didSelectCellSub sendNext:model];
//        [TKFileManager saveValue:model.address forKey:KBindingWalletAddress];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ------eventResponse------

#pragma mark - ------getter & setter------
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleL.textColor = [UIColor blackColor];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.text = SOLocalizedStringFromTable(@"selWallet", nil);
    }
    return _titleL;
}
@end
