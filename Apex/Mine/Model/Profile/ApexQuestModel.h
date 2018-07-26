//
//  ApexQuestItemModel.h
//  Apex
//
//  Created by yulin chi on 2018/7/24.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ApexQuestType) {
    ApexQuestType_Texting,
    ApexQuestType_singleRow,
    ApexQuestType_DoubleRows,
    ApexQuestType_TripleRows,
    ApexQuestType_Tags,
    ApexQuestType_NewPage,
    ApexQuestType_Local
};

@class ApexQuestItemBaseObject;

@interface ApexQuestModel : NSObject
@property (nonatomic, assign) ApexQuestType type; /**< quest type */
@property (nonatomic, strong) NSString *title; /**< title */
@property (nonatomic, assign) NSInteger resource; /**< local or network */
@property (nonatomic, strong) NSArray<ApexQuestItemBaseObject*> *data; /**<  */
@property (nonatomic, strong) NSNumber *realTypeNum; /**<  */

@property (nonatomic, strong) id userSelection; /**< 用model来存储用户的选择/填写内容/选择的tags */
@end


@interface ApexQuestItemBaseObject : NSObject<NSCoding>
@property (nonatomic, strong) NSString *name; /**<  */
@property (nonatomic, strong) NSString *item_id; /**< id */

@end
