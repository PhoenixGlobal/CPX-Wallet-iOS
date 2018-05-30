//
//  ApexPassWordConfirmAlertView.m
//  Apex
//
//  Created by chinapex on 2018/5/24.
//  Copyright © 2018年 Chinapex. All rights reserved.
//

#import "ApexPassWordConfirmAlertView.h"
#import "FCAlertView.h"

@implementation ApexPassWordConfirmAlertView
+ (void)showDeleteConfirmAlertAddress:(NSString *)address subTitle:(NSString*)subtitle Success:(successBlock)success fail:(dispatch_block_t)fail{
    FCAlertView *alert = [[FCAlertView alloc] init];
    UITextField *customField = [[UITextField alloc] init];
    customField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    customField.font = [UIFont systemFontOfSize:13];
    customField.borderStyle = UITextBorderStyleRoundedRect;
    customField.secureTextEntry = YES;
    __block NSString *password = nil;
    [alert addTextFieldWithCustomTextField:customField andPlaceholder:@"Password" andTextReturnBlock:^(NSString *text) {
        password = text;
    }];
    [alert showAlertWithTitle:@"请输入密码" withSubtitle:subtitle withCustomImage:nil withDoneButtonTitle:@"确认" andButtons:@[@"取消"]];
    
    if (subtitle.length > 0) {
        alert.doneButtonTitleColor = [UIColor redColor];
    }
    
    [alert doneActionBlock:^{
        [customField resignFirstResponder];
        NSString *keystore = [PDKeyChain load:KEYCHAIN_KEY(address)];
        NeomobileWallet *wallet = nil;
        NSError *err = nil;
        if (keystore) {
            wallet = NeomobileFromKeyStore(keystore, password, &err);
        }
        
        if (err) {
            if (fail) {
                fail();
            }
            return;
        }
        
        if (success) {
            success(wallet);
        }
    }];
}
@end
