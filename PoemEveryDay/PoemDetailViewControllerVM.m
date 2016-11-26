//
//  PoemDetailViewControllerVM.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "PoemDetailViewControllerVM.h"
#import "WebRequest.h"

@implementation PoemDetailViewControllerVM{
    NSInteger _programID;
}

- (instancetype)initWithProgramID:(NSInteger)programID{
    self = [super init];
    if (self) {
        _programID = programID;
    }
    return self;
}

- (void)requestDetailPoem:(void(^)(PoemDetailDataStruc *detailDataStruc))completionBlock{
    [WebRequest requestPoemDetailWithID:_programID compeletionBlock:^(NSDictionary *jsonDic) {
        completionBlock(nil);
    }];
}

@end
