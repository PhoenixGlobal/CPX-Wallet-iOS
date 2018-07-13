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
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation ApexTransferHistoryController

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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - ------private------
- (void)initUI{
    self.navigationItem.titleView = self.titleL;
    [self.view addSubview:self.transactionView];
    [self.transactionView reloadTransactionData];
}

- (void)setNav{
    UIImage *image = [UIImage imageNamed:@"back-4"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ------getter & setter------
- (ApexTransactionRecordView *)transactionView{
    if (!_transactionView) {
        _transactionView = [[ApexTransactionRecordView alloc] initWithFrame:self.view.bounds];
    }
    return _transactionView;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = SOLocalizedStringFromTable(@"Transaction Records", nil);
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}
@end
