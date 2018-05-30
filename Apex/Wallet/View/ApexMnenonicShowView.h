//
//  ApexMnenonicShowView.h
//  Apex
//
//  Created by chinapex on 2018/5/30.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RouteNameEvent_ShowViewDidDeselectWord @"RouteNameEvent_ShowViewDidDeselectWord"

@interface ApexMnenonicShowView : UICollectionView
@property (nonatomic, strong) NSMutableArray *selArr;

- (void)addNewWord:(NSString*)word;
- (void)deleteWord:(NSString*)word;
@end
