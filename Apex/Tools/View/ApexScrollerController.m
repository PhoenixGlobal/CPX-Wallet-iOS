//
//  ApexScrollerController.m
//  Apex
//
//  Created by yulin chi on 2018/6/1.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexScrollerController.h"

#define LayersDelta 35.0
#define layersSubtle 30.0


@interface ApexScrollerController ()
@property (nonatomic, strong) UIView *baseView; /**< 中间层 */
@property (nonatomic, assign) CGFloat translateOffset; /**< tableview的初始offset*/
@property (nonatomic, assign) CGFloat translateLength; /**<  第一个cell距离navbar的距离*/
@property (nonatomic, assign) CGFloat lastPercent; /**<  */
@property (nonatomic, strong) UIColor *navColor;
@end

@implementation ApexScrollerController
#pragma mark - ------life cycle------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollController_InitUI];
    [self subAddObserver];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_navColor) {
        [self.navigationController lt_setBackgroundColor:_navColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _navColor = self.navigationController.overlay.backgroundColor;
    
}

- (void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [self.tableView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

#pragma mark - ------private------
- (void)scrollController_InitUI{
    
    self.baseColor = [ApexUIHelper navColor];
    
    if (IS_IPHONE_X) {
        self.firstLayerDelta = 180 - NavBarHeight;
    }else{
        self.firstLayerDelta = 160 - NavBarHeight;
    }
    
    self.view.backgroundColor = self.baseColor;
//    [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.baseView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.accessoryBaseView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.contentInset = UIEdgeInsetsMake(_firstLayerDelta-layersSubtle, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -(_firstLayerDelta-layersSubtle));
    
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
    self.lastPercent = 0;
}

- (void)subAddObserver{
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *x = change[NSKeyValueChangeNewKey];
        
        CGFloat offSetY = x.CGPointValue.y;
        if (self.translateOffset == -99999) {
            self.translateOffset = offSetY;
        }
        
        if (offSetY < 0) {
//            [self.navigationController showImageOnNavigationBar:[UIImage new]];
            [self.navigationController lt_setBackgroundColor:[UIColor clearColor]];
        }else{
//            [self.navigationController showImageOnNavigationBar:[UIImage imageNamed:@"bg-2"]];
            [self.navigationController lt_setBackgroundColor:[ApexUIHelper navColor]];
        }
        
        //baseview到navbar的距离
        CGFloat translateDelta = self.translateLength - (offSetY + fabs(self.translateOffset));        
        CGFloat percent = 1.0 - (translateDelta/self.translateLength);
        
        //调整辅助条的alpha
        if (percent<0) {
            self.accessoryBaseView.alpha = 1 + percent*8;
        }else{
            self.accessoryBaseView.alpha = 1 - percent*8;
        }
        
        if (percent <= 1.5) {
            
            if (percent <= 0) {
                self.baseView.transform = CGAffineTransformMakeTranslation(0, -self.firstLayerDelta*percent*0.8);
            }else{
                self.baseView.transform = CGAffineTransformMakeTranslation(0, -self.firstLayerDelta*percent*1.53);
            }
            self.accessoryBaseView.transform = CGAffineTransformMakeTranslation(0, -self.firstLayerDelta*percent);
        }
        
        self.lastPercent = percent;
    }else if ([keyPath isEqualToString:@"contentSize"]){
        NSValue *x = change[NSKeyValueChangeNewKey];
        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(NavBarHeight+self.firstLayerDelta);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(x.CGSizeValue.height <= kScreenH ? kScreenH*2 : x.CGSizeValue.height);
        }];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 5)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - ------eventResponse------

#pragma mark - ------getter & setter------
- (void)setFirstLayerDelta:(CGFloat)firstLayerDelta{
    _firstLayerDelta = firstLayerDelta;
    _translateLength = (_firstLayerDelta - layersSubtle) + LayersDelta;
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)accessoryBaseView{
    if (!_accessoryBaseView) {
        _accessoryBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _accessoryBaseView.backgroundColor = [UIColor clearColor];
    }
    return _accessoryBaseView;
}

@end
