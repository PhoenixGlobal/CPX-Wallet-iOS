//
//  ApexCommonProfileController.m
//  Apex
//
//  Created by yulin chi on 2018/7/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexCommonProfileController.h"
#import "ApexMnemonicFlowLayout.h"
#import "ApexProfileTableViewDatasource.h"

@interface ApexCommonProfileController ()<UITableViewDelegate,UICollectionViewDelegate>
@property (nonatomic, strong) UITableView *tableView; /**<  */
@property (nonatomic, strong) ApexProfileTableViewDatasource *tableViewDatasource; /**<  */
@end

@implementation ApexCommonProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - ------life cycle------
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerClass:[ApexTagSelectCell class] forCellReuseIdentifier:tagCellIdentifier];
    
    [self fakeRequest];
}

- (void)fakeRequest{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fakeProfileResponse" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (NSDictionary *modelDict in dict[@"result"]) {
        ApexQuestModel *model = [ApexQuestModel yy_modelWithDictionary:modelDict];
        [self.tableViewDatasource.contentArr addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - ------private------

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------

#pragma mark - ------getter & setter------
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self.tableViewDatasource;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (ApexProfileTableViewDatasource *)tableViewDatasource{
    if (!_tableViewDatasource) {
        _tableViewDatasource = [[ApexProfileTableViewDatasource alloc] init];
        _tableViewDatasource.tableView = self.tableView;
    }
    return _tableViewDatasource;
}

@end
