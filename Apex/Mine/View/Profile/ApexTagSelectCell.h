//
//  ApexTagSelectCell.h
//  Apex
//
//  Created by yulin chi on 2018/7/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApexQuestModel.h"

@interface ApexTagSelectCell : UITableViewCell
@property (nonatomic, strong) NSArray<ApexQuestItemBaseObject*> *tags; /**<  */
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic, strong) NSMutableArray *selectedTags; /**<  */
@property (nonatomic, assign) BOOL isFromCommon; /**<  */
@end
