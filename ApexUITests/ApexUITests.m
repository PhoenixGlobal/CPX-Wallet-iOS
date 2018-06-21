//
//  ApexUITests.m
//  ApexUITests
//
//  Created by chinapex on 2018/6/21.
//  Copyright © 2018年 Gary. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ApexUITests : XCTestCase
@property (nonatomic, strong) XCUIApplication *application;
@end

@implementation ApexUITests

- (void)setUp {
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
    [self testCreateWallet];
}

- (void)testCreateWallet{
    XCUIElement *leftBtn = [self.application.navigationBars.menuBarItems elementMatchingType:XCUIElementTypeButton identifier:@""];
    [leftBtn tap];
    [[[[self.application.tables elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0] tap];
}

@end
