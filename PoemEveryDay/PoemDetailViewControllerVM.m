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
        dataStruc.poemPictureEnjoy = jsonDic[@"data"][@"poemPicture"][@"imgNew"];
        dataStruc.reciterName = jsonDic[@"data"][@"poemProgramGuestVos"][0][@"gName"];
        dataStruc.reciterCareer = jsonDic[@"data"][@"poemProgramGuestVos"][0][@"typeName"];
        dataStruc.reciterIcon = jsonDic[@"data"][@"poemProgramGuestVos"][0][@"imgNew"];
        dataStruc.imageLink = jsonDic[@"data"][@"poemPicture"][@"imgNew"];
        
        CGFloat heigh = [jsonDic[@"data"][@"poemPicture"][@"imgHeight"] floatValue];
        CGFloat width = [jsonDic[@"data"][@"poemPicture"][@"imgWidth"] floatValue];
        dataStruc.imgHeighWidthRatio = heigh / width;
        
        completionBlock(dataStruc);
    }];
}

@end
