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

#define assetId_CPX @"0x45d493a6f73fa5f404244a5fb8472fc014ca5885"
#define assetId_Neo @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
#define assetId_NeoGas @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7"
#define assetId_Eth @"0x0000000000000000000000000000000000000000"

#define assetID_Test_Erc20 @"0xc7773e07adb2642a1eb03c5e340430b6cedc2aa9"

#define UserDefaultsIdentifier @"com.chinapex.apex"
#define isFirstOpenApp @"isFirstOpenApp"
#define commonScheme @"Apex://"
#define KEYCHAIN_KEY(address) [NSString stringWithFormat:@"%@", address]
#define LASTUPDATETXHISTORY_KEY(address) [NSString stringWithFormat:@"LASTUPDATETXHISTORY_KEY_%@", address]
#define TXRECORD_KEY @"TXRECORD_KEY"
#define KMyAseetArr @"KMyAseetArr"
#define KAssetModelListKey @"KAssetModelListKey"
#define KETHAssetModelListKey @"KETHAssetModelListKey"
#define KLanguageSetting @"KLanguageSetting"
#define KBindingWalletAddress @"KBindingWalletAddress"
#define KBindingAddressToCommonProfile [NSString stringWithFormat:@"address_commonProfile"]
#define KBindingAddressToSpecialProfile [NSString stringWithFormat:@"address_specialProfile"]
#define KisFirstCreateWalletDone  @"KisFirstCreateWalletDone"
#define KglobleWalletType @"KglobleWalletType" //全局的钱包类型key
#define KLocalTXTrackerKey @"KLocalTXTrackerKey" //本地交易状态跟踪key
#define KEthNonceTrackerKey @"KEthNonceTrackerKey" //本地存储的tx的nonce

//neo
#define baseUrl_tool_test @"http://dev.chinapex.com.cn:10086/tool/"
#define baseUrl_cli_test @"http://dev.chinapex.com.cn:10086/neo-cli/"
#define baseUrl_tool_main @"https://tracker.chinapex.com.cn/tool/"
#define baseUrl_cli_main @"https://tracker.chinapex.com.cn/neo-cli/"

//eth
//#define ETH_baseUrl_cli_test @"https://tracker.chinapex.com.cn/eth-cli/"
#define ETH_baseUrl_cli_test @"http://42.159.95.191:8545"
#define ETHApiKey @"CTTVCEUHGU1UMY14IMWH5G9IREY7AAMT1V"

#define neo_assetid @"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
#define neoGas_Assetid @"0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7"

#define mnemonicEnglish @"en_US"
#define mnemonicChianese @"zh_CN"

#define EthType @"Eth"
#define Erc20Type @"Erc20"
#define NeoType @"NEO"

#define NEOPlaceHolder [UIImage imageNamed:@"未标题-1"]
#define ETHPlaceHolder [UIImage imageNamed:@"未标题-1 copy 3"]

#define CPX_Logo [UIImage imageNamed:@"CPX_logo"];
#endif /* Macro_h */
