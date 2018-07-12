//
//  ApexTransferHistoryController.m
//  Apex
//
//  Created by chinapex on 2018/7/12.
//  Copyright © 2018 Gary. All rights reserved.
//

#import "ApexTransferHistoryController.h"
#import "ApexTransactionRecordView.h"
#import "ApexTransactionDetailController.h"

@interface ApexTransferHistoryController ()
@property (nonatomic, strong) ApexTransactionRecordView *transactionView;
@end

@implementation ApexTransferHistoryController

#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController lt_setBackgroundColor:[ApexUIHelper navColor]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)initUI{
    self.title = SOLocalizedStringFromTable(@"Transaction Records", nil);
    [self.view addSubview:self.transactionView];
    [self.transactionView reloadTransactionData];
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------

#pragma mark - ------eventResponse------
- (void)routeEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userinfo{
    if ([eventName isEqualToString:RouteNameEvent_TransactionRecordDetail]){
        ApexWalletModel *model = userinfo[@"wallet"];
        ApexTransactionDetailController *detailVC = [[ApexTransactionDetailController alloc] init];
        detailVC.model = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

#pragma mark - ------getter & setter------
- (ApexTransactionRecordView *)transactionView{
    if (!_transactionView) {
        _transactionView = [[ApexTransactionRecordView alloc] initWithFrame:self.view.bounds];
    }
    return _transactionView;
}
@end
