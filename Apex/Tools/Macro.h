//
//  Macro.h
//  Apex
//
//  Created by chinapex on 2018/5/7.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define NavBarHeight [ApexUIHelper naviBarHeight]
#define kScale [UIScreen mainScreen].scale
#define scaleWidth375(w) w/375.0 * kScreenW
#define scaleHeight667(h) h/667.0 * kScreenH

#define UserDefaultsIdentifier @"com.chinapex.apex"
#define isFirstOpenApp @"isFirstOpenApp"
#define commonScheme @"Apex://"
#define KEYCHAIN_KEY(address) [NSString stringWithFormat:@"%@", address]
#define TXRECORD_KEY @"TXRECORD_KEY"
#endif /* Macro_h */
