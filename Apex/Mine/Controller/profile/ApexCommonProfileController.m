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
@property (nonatomic, strong) UIButton *saveBtn; /**<  */
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
    [self.view addSubview:self.saveBtn];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.saveBtn.mas_top).offset(10);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApexTagSelectCell" bundle:nil] forCellReuseIdentifier:tagCellIdentifier];
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexQuestModel *model = self.tableViewDatasource.contentArr[indexPath.row];
    switch (model.type) {
        case ApexQuestType_Texting:
            
            break;
        case ApexQuestType_singleRow:
            
            break;
        case ApexQuestType_DoubleRows:
            
            break;
        case ApexQuestType_TripleRows:
            
            break;
        case ApexQuestType_Tags:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - ------eventResponse------

#pragma mark - ------getter & setter------
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self.tableViewDatasource;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        _saveBtn.backgroundColor = [ApexUIHelper mainThemeColor];
        _saveBtn.layer.cornerRadius = 6;
        [_saveBtn setTitle:SOLocalizedStringFromTable(@"Save", nil) forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveBtn;
}

@end
