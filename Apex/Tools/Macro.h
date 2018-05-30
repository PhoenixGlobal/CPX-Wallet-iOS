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

#define baseUrl @"http://40.125.171.0:8083"

#define neo_assetid @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
#define neoGas_Assetid @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7"

#define mnemonicEnglish @"en_US"
#define mnemonicChianese @"zh_CN"
#endif /* Macro_h */
