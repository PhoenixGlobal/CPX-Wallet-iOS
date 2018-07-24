//
//  ApexMnemonicCell.h
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexMnemonicCell : UICollectionViewCell
@property (nonatomic, strong) NSString *mnemonicStr;
@property (nonatomic, assign) BOOL choose;
@property (nonatomic, strong) UIColor *baseColor; /**< <#annotaion#> */
@end
