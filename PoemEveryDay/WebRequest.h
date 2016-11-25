//
//  WebRequest.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/24.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebRequest : NSObject

+ (void)requestCoverListData:(NSInteger)page pageNum:(NSInteger)pageNum compeletionBlock:(void(^)(NSDictionary *jsonDic))compeletionBlock;

+ (void)requestPoemDetailWithID:(NSInteger)programID compeletionBlock:(void(^)(NSDictionary *jsonDic))compeletionBlock;

@end
