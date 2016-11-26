//
//  RootViewControllerVM.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "RootViewControllerVM.h"
#import "WebRequest.h"
#import "CoverListDataStruc.h"
#import "DataViewControllerVM.h"

@interface RootViewControllerVM()
@property (nonatomic, strong) NSDictionary *coverListJsonDic;
@end

@implementation RootViewControllerVM{
}

- (void)requestCoverList:(void(^)(NSArray *list))compeletionBlock;{
    WeakSelf
    [WebRequest requestCoverListData:1 pageNum:10 compeletionBlock:^(NSDictionary *jsonDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!jsonDic) {
                compeletionBlock(nil);
                return ;
            }
            weakSelf.coverListJsonDic = jsonDic;
            compeletionBlock(weakSelf.coverListAry);
        });
    }];
}

- (void)setCoverListJsonDic:(NSDictionary *)coverListJsonDic{
    _coverListJsonDic = coverListJsonDic;
    
    NSMutableArray *coverListAry = [[NSMutableArray alloc] init];
    NSArray *data = coverListJsonDic[@"data"];
    for (NSDictionary *poem in data) {
        CoverListDataStruc *poemData = [CoverListDataStruc new];
        poemData.programID = [poem[@"programId"] integerValue];
        poemData.date = [NSString stringWithFormat:@"%@ %@ %@",poem[@"publicAtMonthStr"],poem[@"publicAtDayStr"],poem[@"publicAtYearStr"]];
        NSDictionary *covers = poem[@"covers"];
        poemData.summary = covers[@"summary"];
        poemData.title = covers[@"title"];
        poemData.imageLink = covers[@"imgNew"];
        NSDictionary *guests = [poem[@"guests"] objectAtIndex:0];
        poemData.reciterName = guests[@"gName"];
        [coverListAry addObject:poemData];
    }
    
    _coverListAry = coverListAry;
}

- (DataViewControllerVM *)getDataVCViewModelWithIndex:(NSInteger)index{
    DataViewControllerVM *viewModel = [DataViewControllerVM new];
    viewModel.dataObject = _coverListAry[index];
    return viewModel;
}

@end
