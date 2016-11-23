//
//  PoemEveryDayTests.m
//  PoemEveryDayTests
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+Base64AES128CBC.h"

@interface PoemEveryDayTests : XCTestCase

@end

@implementation PoemEveryDayTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBase64AES128CoverList {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *getCoverList = @"http://api.thepoemforyou.com/cover/getCoverList?p=";
    NSString *sourceString = [NSString stringWithFormat:@"pageNo=%d&pageSize=%d",1,10];
    NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [sourceData AES128EncryptWithKey:@""];
    NSString *finalString = [encryptData base64EncodedString];
    NSString* escapedUrlString= (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(
                                                                                                       NULL,
                                                                                                       (CFStringRef)finalString,
                                                                                                       NULL,
                                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                       kCFStringEncodingUTF8 );
    NSString *url = [NSString stringWithFormat:@"%@%@",getCoverList,escapedUrlString];
    NSLog(@"final url = %@",url);
}

- (void)testSearchFindByID{
    NSString *searchFindByID = @"http://api.thepoemforyou.com/search/searchFindById?p=";
    NSString *sourceString = [NSString stringWithFormat:@"id=%d",1240];
    NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [sourceData AES128EncryptWithKey:@""];
    NSString *finalString = [encryptData base64EncodedString];
    NSString* escapedUrlString= (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(
                                                                                                       NULL,
                                                                                                       (CFStringRef)finalString,
                                                                                                       NULL,
                                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                       kCFStringEncodingUTF8 );
    NSString *url = [NSString stringWithFormat:@"%@%@",searchFindByID,escapedUrlString];
    NSLog(@"final url = %@",url);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
