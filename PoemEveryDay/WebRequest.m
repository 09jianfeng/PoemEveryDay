//
//  WebRequest.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/24.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "WebRequest.h"
#import "URLCreator.h"

@implementation WebRequest

+ (void)requestCoverListData:(NSInteger)page pageNum:(NSInteger)pageNum compeletionBlock:(void(^)(NSDictionary *jsonDic))compeletionBlock;{
    NSString *coverList = [URLCreator poemListURLString:pageNum count:pageNum];
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithURL:[NSURL URLWithString:coverList] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"warning coverlist error %@",error);
            compeletionBlock(nil);
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        compeletionBlock(jsonDic);
        
    }];
    [dataTask resume];
}

+ (void)requestPoemDetailWithID:(NSInteger)programID compeletionBlock:(void(^)(NSDictionary *jsonDic))compeletionBlock{
    NSString *detailURLString = [URLCreator poemDetailURLString:programID];
    NSURLSession *shareSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithURL:[NSURL URLWithString:detailURLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"warning coverlist error %@",error);
            compeletionBlock(nil);
            return ;
        }
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        compeletionBlock(jsonDic);
    }];
    [dataTask resume];
}

@end
