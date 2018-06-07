//
//  ApexExportKeystoreQRView.h
//  Apex
//
//  Created by chinapex on 2018/6/7.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApexExportKeystoreQRView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *QRImageV;
@property (nonatomic, strong) NSString *address;
@end
