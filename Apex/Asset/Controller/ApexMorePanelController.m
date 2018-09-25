//
//  ApexMorePanelController.m
//  Apex
//
//  Created by chinapex on 2018/6/5.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexMorePanelController.h"
#import "ApexMoreTopCell.h"
#import "ApexMoreFuncCell.h"
#import "ApexCreatWalletController.h"
#import "ApexScanAction.h"
#import "ApexImportWalletController.h"
#import "ApexDrawTransPercentDriven.h"

@interface ApexMorePanelController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@end

@implementation ApexMorePanelController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _leftItem = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.leftBarButtonItem = _leftItem;
}

#pragma mark - ------private------
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController lt_setBackgroundColor:[ApexUIHelper navColor]];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.width.mas_equalTo(scaleWidth375(150));
    }];
    
    [self.tableView registerClass:[ApexMoreTopCell class] forCellReuseIdentifier:@"topCell"];
    [self.tableView registerClass:[ApexMoreFuncCell class] forCellReuseIdentifier:@"funcCell"];
}


#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ApexMoreTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"topCell" forIndexPath:indexPath];
        if (!self.typeArr || self.typeArr.count == 0) {
            topCell.hidden = YES;
        }else{
            topCell.typeArr = self.typeArr;
        }
        return topCell;
    }else{
        ApexMoreFuncCell *funcCell = [tableView dequeueReusableCellWithIdentifier:@"funcCell" forIndexPath:indexPath];
        funcCell.configArr = self.funcConfigArr;
        return funcCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.typeArr.count * 44;
    }else{
        return 44*self.funcConfigArr.count;
    }
}

#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_FuncCellDidClickScan]){
        [ApexScanAction shareScanHelper].curWallet = self.curWallet;
        [ApexScanAction shareScanHelper].balanceMode = self.balanceModel;
        [ApexScanAction scanActionOnViewController:self];
    }else if ([eventName isEqualToString:RouteNameEvent_FuncCellDidClickCreat]){
        ApexCreatWalletController *wvc = [[ApexCreatWalletController alloc] init];
        wvc.hidesBottomBarWhenPushed = YES;
        [self directlyPushToViewControllerWithSelfDeleted:wvc];
    }else if ([eventName isEqualToString:RouteNameEvent_FuncCellDidClickImport]){
        ApexImportWalletController *imvc = [[ApexImportWalletController alloc] init];
        imvc.hidesBottomBarWhenPushed = YES;
        [self directlyPushToViewControllerWithSelfDeleted:imvc];
    }else if ([eventName isEqualToString:RouteNameEvent_TopWalletCellDidChooseWallet]){
        NSString *type = userinfo[@"type"];
        if (self.didChangeTypeSub) {
            [self.didChangeTypeSub sendNext:type];
            [self.navigationController popViewControllerAnimated:YES];
            [[ApexDrawTransPercentDriven shareDriven] startTranstionWithDuration:0.5 fromVC:self];
        }
    }
}

#pragma mark - ------getter & setter------
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
