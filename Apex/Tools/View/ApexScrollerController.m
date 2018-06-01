//
//  ApexScrollerController.m
//  Apex
//
//  Created by yulin chi on 2018/6/1.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexScrollerController.h"

#define LayersDelta 35.0



@interface ApexScrollerController ()
@property (nonatomic, strong) UIView *baseView; /**< 中间层 */
@property (nonatomic, assign) CGFloat translateOffset; /**< tableview的初始offset*/
@property (nonatomic, assign) CGFloat translateLength; /**<  第一个cell距离navbar的距离*/
@property (nonatomic, strong) UIView *accessoryBaseView; /**<  */
@end

@implementation ApexScrollerController
#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self addEvent];
}


#pragma mark - ------private------
- (void)initUI{
    
    self.title = @"自残";
    self.view.backgroundColor = self.baseColor;
    [self.navigationController lt_setBackgroundColor:self.baseColor];
    
    [self.view addSubview:self.baseView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.accessoryBaseView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.contentInset = UIEdgeInsetsMake(_firstLayerDelta-60, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -(_firstLayerDelta-60));
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavBarHeight+self.firstLayerDelta);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavBarHeight);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [self.accessoryBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView.mas_top).offset(-(LayersDelta+15));
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    self.translateOffset = -99999;
    
}

#pragma mark - ------public------

#pragma mark - ------delegate & datasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

#pragma mark - ------eventResponse------
- (void)addEvent{
    @weakify(self);
    [[RACObserve(self.tableView, contentOffset) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSValue *x) {
        @strongify(self);
        CGFloat offSetY = x.CGPointValue.y;
        if (self.translateOffset == -99999) {
            self.translateOffset = offSetY;
        }
        
        CGFloat translateDelta = self.translateLength - (offSetY + fabs(self.translateOffset));
        CGFloat percent = 1.0 - (translateDelta/self.translateLength);
        
        if (percent <= 1.5) {
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -self.firstLayerDelta*percent);
            self.baseView.transform = transform;
            self.accessoryBaseView.transform = transform;
        }
    }];
    
    
    [[[RACObserve(self.tableView, contentSize) takeUntil:self.rac_willDeallocSignal] distinctUntilChanged] subscribeNext:^(NSValue *x) {
        @strongify(self);
        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavBarHeight+self.firstLayerDelta);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(x.CGSizeValue.height);
        }];
    }];
}

#pragma mark - ------getter & setter------
- (void)setFirstLayerDelta:(CGFloat)firstLayerDelta{
    _firstLayerDelta = firstLayerDelta;
    _translateLength = (_firstLayerDelta - 60.0) + LayersDelta;
}

- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [ApexUIHelper grayColor240];
    }
    return _baseView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)accessoryBaseView{
    if (!_accessoryBaseView) {
        _accessoryBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _accessoryBaseView.backgroundColor = [UIColor whiteColor];
    }
    return _accessoryBaseView;
}

@end
