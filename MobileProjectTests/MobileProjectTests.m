//
//  MobileProjectTests.m
//  MobileProjectTests
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPCheckBankCard.h"
#import "MPUtils.h"

@interface MobileProjectTests : XCTestCase

@end

@implementation MobileProjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testCheckBankCard
{
    //6228480402564890018  -- 有效卡号
    BOOL isValid = [MPCheckBankCard checkBankCard:@"6228480402564890018"];
    XCTAssertTrue(isValid);
    
    //6228480402564890019 --无效卡号
    isValid = [MPCheckBankCard checkBankCard:@"6228480402564890019"];
    XCTAssertFalse(isValid);
}

- (void)testUtils
{
    //MAUtils工具类测试用例
    BOOL isValid = [MPUtils isEmptyString:@""];
    XCTAssertTrue(isValid);
    
    isValid = [MPUtils isEmptyString:@"test"];
    XCTAssertFalse(isValid);
    
    isValid = [MPUtils isValidateCarNo:@"abde"];
    XCTAssertFalse(isValid);
    
    isValid = [MPUtils isValidateCarNo:@"AB1729"];
    XCTAssertTrue(isValid);
    
    isValid = [MPUtils isValidateEmail:@"abc"];
    XCTAssertFalse(isValid);
    
    isValid = [MPUtils isValidateEmail:@"abc@163.com"];
    XCTAssertTrue(isValid);
    
    isValid = [MPUtils isValidateIDCard:@"330184198501184115"];  //有效的身份证号
    XCTAssertTrue(isValid);
    
    isValid = [MPUtils isValidateIDCard:@"33018419850118411"];  //无效的身份证号
    XCTAssertFalse(isValid);
    
    isValid = [MPUtils isValidateMobile:@"13266611281"];   //有效的手机号
    XCTAssertTrue(isValid);
    
    isValid = [MPUtils isValidateMobile:@"10066611281"];  //无效的手机号
    XCTAssertFalse(isValid);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
