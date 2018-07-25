//
//  ApexRowSelectView.h
//  Apex
//
//  Created by yulin chi on 2018/7/25.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApexQuestItemBaseObject;
typedef void(^didSelectRow)(ApexQuestItemBaseObject* obj);

@interface ApexRowSelectView : UIView
+ (void)showSingleRowSelectViewWithContentArr:(NSArray*)contentArr CompleteHandler:(didSelectRow)handler;
@end
