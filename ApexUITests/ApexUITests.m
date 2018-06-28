//
//  ApexuITests.m
//  ApexuITests
//
//  Created by chinapex on 2018/6/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ApexuITests : XCTestCase
@property (nonatomic, strong) XCUIApplication *application;
@end

@implementation ApexuITests

- (void)setup {
    [super setUp];
    self.continueAfterFailure = NO;
    self.application = [[XCUIApplication alloc] init];
    [self.application launch];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
//    [self importFromMnemonic];
    [self testImportFromKs];
    
    
    
}

- (void)testTransfer{
    
}

- (void)importFromMnemonic{
    XCUIApplication *app = [[XCUIApplication alloc] init];
//    [app.buttons[@"\u5bfc\u5165\u94b1\u5305"] tap];
    [app.textViews[@"\u52a9\u8bb0\u8bcd,\u6309\u7a7a\u683c\u5206\u9694"] tap];
    [app.textViews[@"\u52a9\u8bb0\u8bcd,\u6309\u7a7a\u683c\u5206\u9694"] typeText:@"icon when engine hood race eagle industry warfare invite like organ dose bulb purpose man cave nothing panda code between bracket eye fancy scrub"];
    [app.toolbars[@"Toolbar"].buttons[@"Toolbar Done Button"] tap];
    
    [app.secureTextFields[@"\u5bc6\u7801(\u4e0d\u5c11\u4e8e6\u4e2a\u5b57\u7b26)"] tap];
    [app.secureTextFields[@"\u5bc6\u7801(\u4e0d\u5c11\u4e8e6\u4e2a\u5b57\u7b26)"] typeText:@"111111"];
    [app.toolbars[@"Toolbar"].buttons[@"Toolbar Done Button"] tap];
    
    [app.secureTextFields[@"\u91cd\u590d\u5bc6\u7801(\u4e0d\u5c11\u4e8e6\u4e2a\u5b57\u7b26)"] tap];
    [app.secureTextFields[@"\u91cd\u590d\u5bc6\u7801(\u4e0d\u5c11\u4e8e6\u4e2a\u5b57\u7b26)"] typeText:@"111111"];
    [app.toolbars[@"Toolbar"].buttons[@"Toolbar Done Button"] tap];
    
    [app.buttons[@"Group 3 1"] tap];
    
    [app.buttons[@"\u5f00\u59cb\u5bfc\u5165"] tap];
}

- (void)testImportFromKs{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.textViews[@"Keystore \u6587\u672c\u5185\u5bb9"] tap];
    [app.textViews[@"Keystore \u6587\u672c\u5185\u5bb9"] typeText:@"{\"address\":\"ALDbmTMY54RZnLmibH3eXfHvrZt4fLiZhh\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"4b702f33095dd5ce5dae111d193f8dc0aa8147b30bd7d6e54bc2a29973958669\",\"cipherparams\":{\"iv\":\"1789b1a1db9583ec062a12443e30bcbb\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":4096,\"p\":6,\"r\":8,\"salt\":\"144ff9d51e45ea1189fb00db1bb4beff30580792d98d046c42b531bb3735510d\"},\"mac\":\"1e355c4c4abe6f97358169a6c52e3a0193de4d550eabfd31a384a71769f8b917\"},\"id\":\"bed5859a-40a9-4a42-ba90-38e480b94a19\",\"version\":3}"];
    [app.toolbars[@"Toolbar"].buttons[@"Toolbar Done Button"] tap];
    
    [app.secureTextFields[@"\u5bc6\u7801"] tap];
    [app.secureTextFields[@"\u5bc6\u7801"] typeText:@"123"];
    [app.toolbars[@"Toolbar"].buttons[@"Toolbar Done Button"] tap];
    
    [app.buttons[@"Group 3 1"] tap];
    [app.buttons[@"\u5f00\u59cb\u5bfc\u5165"] tap];
}

@end
