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

#pragma mark - ------life cycle------
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    }
    return _tableView;
}

- (ApexProfileTableViewDatasource *)tableViewDatasource{
    if (!_tableViewDatasource) {
        _tableViewDatasource = [[ApexProfileTableViewDatasource alloc] init];
    }
    return _tableViewDatasource;
}

@end
