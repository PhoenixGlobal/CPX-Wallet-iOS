//
//  PublicEnum.h
//  Apex
//
//  Created by chinapex on 2018/6/8.
//  Copyright © 2018年 Gary. All rights reserved.
//

#ifndef PublicEnum_h
#define PublicEnum_h

/**< 侧滑栏的功能配置 */
typedef NS_ENUM(NSInteger, PanelFuncConfig) {
    PanelFuncConfig_Scan = 0,
    PanelFuncConfig_Create,
    PanelFuncConfig_Import
};

/**< 钱包交易状态 */
typedef NS_ENUM(NSInteger,ApexTransferStatus) {
    ApexTransferStatus_Blocking = 109871, /**< 打包中 */
    ApexTransferStatus_Progressing,     /**< 确认中 */
    ApexTransferStatus_Confirmed,       /**< 交易成功 */
    ApexTransferStatus_Failed,           /**< 交易失败 */
    ApexTransferStatus_Error
};

/**< 全局的钱包类型*/
typedef NS_ENUM(NSInteger, ApexWalletType) {
    ApexWalletType_Neo,
    ApexWalletType_Eth
};

#endif /* PublicEnum_h */
