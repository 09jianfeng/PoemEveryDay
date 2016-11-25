//
//  URLCreator.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "URLCreator.h"
#import "NSData+Base64AES128CBC.h"

@implementation URLCreator

+ (NSString *)poemListURLString:(NSInteger)page count:(NSInteger)count{
    NSString *getCoverList = @"http://api.thepoemforyou.com/cover/getCoverList?p=";
    NSString *sourceString = [NSString stringWithFormat:@"pageNo=%td&pageSize=%td",page,count];
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
    NSLog(@"coverList %@",url);
    return url;
}

+ (NSString *)poemDetailURLString:(NSInteger)programID{
    NSString *searchFindByID = @"http://api.thepoemforyou.com/search/searchFindById?p=";
    NSString *sourceString = [NSString stringWithFormat:@"id=%td",programID];
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
    NSLog(@"detailURL %@",url);
    return url;
}

@end
