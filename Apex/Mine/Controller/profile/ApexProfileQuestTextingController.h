//
//  ApexProfileQuestTextingController.h
//  Apex
//
//  Created by yulin chi on 2018/7/26.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApexQuestModel;
@interface ApexProfileQuestTextingController : UIViewController
@property (nonatomic, strong) RACSubject *didConfirmTextSubject; /**<  */
@property (nonatomic, strong) ApexQuestModel *model; /**<  */
@end
