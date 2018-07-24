//
//  ApexTagSelectCell.h
//  Apex
//
//  Created by yulin chi on 2018/7/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApexQuestItemBaseObject;
@interface ApexTagSelectCell : UITableViewCell
@property (nonatomic, strong) NSArray<ApexQuestItemBaseObject*> *tags; /**<  */
//@property (nonatomic, strong) RACSubject *collectionView; /**< <#annotaion#> */
@end
