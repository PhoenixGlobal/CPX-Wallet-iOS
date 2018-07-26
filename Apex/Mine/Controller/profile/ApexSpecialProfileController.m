//
//  ApexSpecialProfileController.m
//  Apex
//
//  Created by yulin chi on 2018/7/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexSpecialProfileController.h"
#import "ApexMnemonicFlowLayout.h"
#import "ApexProfileTableViewDatasource.h"
#import "ApexSimpleDatePicker.h"
#import "ApexRowSelectView.h"
#import "ApexProfileQuestTextingController.h"
#import "ApexLoading.h"

@interface ApexSpecialProfileController ()<UITableViewDelegate,UICollectionViewDelegate>
@property (nonatomic, strong) UITableView *tableView; /**<  */
@property (nonatomic, strong) ApexProfileTableViewDatasource *tableViewDatasource; /**<  */
@property (nonatomic, strong) UIButton *saveBtn; /**<  */

@property (nonatomic, strong) NSMutableDictionary *answerDict; /**<  */

@end

@implementation ApexSpecialProfileController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self handleEvent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - ------private------
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
    
    [self.tableView registerClass:[ApexNormalQuestCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApexTagSelectCell" bundle:nil] forCellReuseIdentifier:tagCellIdentifier];
    
    [self fakeRequest];
}

- (void)fakeRequest{
    NSString *path = @"";
    
    if ([[SOLocalization sharedLocalization].region isEqualToString:SOLocalizationEnglish]) {
        path = [[NSBundle mainBundle] pathForResource:@"specialQuest_en" ofType:@"json"];
    }else{
        path = [[NSBundle mainBundle] pathForResource:@"specialQuest_zh" ofType:@"json"];
    }
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (NSDictionary *modelDict in dict[@"result"]) {
        ApexQuestModel *model = [ApexQuestModel yy_modelWithDictionary:modelDict];
        [self.tableViewDatasource.contentArr addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApexQuestModel *model = self.tableViewDatasource.contentArr[indexPath.row];
    switch (model.type) {
        case ApexQuestType_Texting:{
            ApexProfileQuestTextingController *vc = [[ApexProfileQuestTextingController alloc] init];
            vc.model = model;
            vc.didConfirmTextSubject = [RACSubject subject];
            [vc.didConfirmTextSubject subscribeNext:^(NSString *text) {
                model.userSelection = text;
                [tableView reloadData];
                [self.answerDict setValue:text forKey:model.title];
            }];
            [self.baseController.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case ApexQuestType_singleRow:{
            
            [ApexRowSelectView showSingleRowSelectViewWithContentArr:model.data CompleteHandler:^(ApexQuestItemBaseObject *obj) {
                model.userSelection = obj;
                [tableView reloadData];
                [self.answerDict setValue:obj.name forKey:model.title];
            }];
        }
            break;
        case ApexQuestType_DoubleRows:
            
            break;
        case ApexQuestType_TripleRows:{
            //目前只有生日
            [ApexSimpleDatePicker showDatePickerCompleteHandler:^(NSDate *date, NSString *dateStr) {
                model.userSelection = dateStr;
                [tableView reloadData];
                [self.answerDict setValue:dateStr forKey:model.title];
            }];
        }
            break;
        case ApexQuestType_Tags:
            
            break;
            
        default:
            break;
    }
}

- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
#pragma mark - ------eventResponse------
- (void)handleEvent{
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [ApexLoading showOnView:self.view Message:SOLocalizedStringFromTable(@"loading", nil)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self getRandomNumber:0 to:3] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ApexLoading hideOnView:self.view];
            NSString *bindingAddress = [TKFileManager ValueWithKey:KBindingWalletAddress];
            //save answer
            [PDKeyChain save:KBindingAddressToSpecialProfile(bindingAddress) data:self.answerDict];
        });
    }];
}


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

- (NSMutableDictionary *)answerDict{
    if (!_answerDict) {
        _answerDict = [NSMutableDictionary dictionary];
    }
    return _answerDict;
}
@end
