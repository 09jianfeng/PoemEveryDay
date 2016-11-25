//
//  URLCreator.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLCreator : NSObject

+ (NSString *)poemListURLString:(NSInteger)page count:(NSInteger)count;

+ (NSString *)poemDetailURLString:(NSInteger)programID;

@end
