//
//  PoemDetailViewControllerVM.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "PoemDetailViewControllerVM.h"
#import "WebRequest.h"
#import "PoemDetailDataStruc.h"

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
        if (!jsonDic) {
            return ;
        }
        
        PoemDetailDataStruc *dataStruc = [PoemDetailDataStruc new];
        dataStruc.author = jsonDic[@"data"][@"audio"][@"audioGps"][0][@"poetry"][@"authors"][@"author"];
        dataStruc.original = jsonDic[@"data"][@"audio"][@"audioGps"][0][@"poetry"][@"original"];
        dataStruc.translator = jsonDic[@"data"][@"audio"][@"audioGps"][0][@"poetry"][@"translator"];
        dataStruc.poemTitle = jsonDic[@"data"][@"audio"][@"audioGps"][0][@"poetry"][@"title"];
        dataStruc.headerTitle = jsonDic[@"data"][@"title"];
        dataStruc.poemEnjoy = jsonDic[@"data"][@"poemProgramPenjoys"][0][@"poetryEnjoy"];
        
        completionBlock(dataStruc);
    }];
}

@end
