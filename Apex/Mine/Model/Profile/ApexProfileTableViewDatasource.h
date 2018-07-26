//
//  ApexProfileTableViewDatasource.h
//  Apex
//
//  Created by yulin chi on 2018/7/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApexQuestModel.h"
#import "ApexTagSelectCell.h"
#import "ApexNormalQuestCell.h"

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *tagCellIdentifier = @"tagCellIdentifier";

@interface ApexProfileTableViewDatasource : NSObject<UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<ApexQuestModel*> *contentArr; /**<  */
@property (nonatomic, strong) UITableView *tableView; /**<  */
@property (nonatomic, assign) BOOL isFromCommon; /**<  */
@property (nonatomic, strong) NSDictionary *showDict; /**<  */
@end
