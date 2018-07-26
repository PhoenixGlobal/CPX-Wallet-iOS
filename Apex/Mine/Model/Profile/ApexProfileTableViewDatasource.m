//
//  ApexProfileTableViewDatasource.m
//  Apex
//
//  Created by yulin chi on 2018/7/23.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import "ApexProfileTableViewDatasource.h"

@implementation ApexProfileTableViewDatasource
#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApexQuestModel *model = self.contentArr[indexPath.row];
    if (model.type == ApexQuestType_Tags) {
        ApexTagSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellIdentifier forIndexPath:indexPath];
        cell.isFromCommon = self.isFromCommon;
        cell.titleL.text = model.title;
        cell.tags = model.data;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showDict = self.showDict;
        model.userSelection = cell.selectedTags;
        return cell;
    }else{
        ApexNormalQuestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.isFromCommon = self.isFromCommon;
        cell.model = model;
        cell.showDict = self.showDict;
        [cell addLinecolor:[UIColor colorWithHexString:@"eeeeee"] edge:UIEdgeInsetsMake(-1, 15, 0, 0)];
        return cell;
    }
}

#pragma mark - private

#pragma mark - getter
- (void)setShowDict:(NSDictionary *)showDict{
    _showDict = showDict;
}

- (NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
@end
