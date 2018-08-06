//
//  ApexScrollerController.h
//  Apex
//
//  Created by yulin chi on 2018/6/1.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexScrollerController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *baseView; /**< 中间层 */
@property (nonatomic, strong) UIColor *baseColor; /**< backGroudColor */
@property (nonatomic, strong) UITableView *tableView; /**<  */
@property (nonatomic, assign) CGFloat firstLayerDelta; /**< 白色baseview与navbar之间的高度 */
@property (nonatomic, strong) UIView *accessoryBaseView; /**<  */
@property (nonatomic, assign) BOOL shouldChildControlNavBarAppreance; /**< 是否让子类来管理导航栏的外观 */
@end
