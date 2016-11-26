//
//  PoemDetailViewControllerVM.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoverListDataStruc;
@class PoemDetailDataStruc;

@interface PoemDetailViewControllerVM : NSObject

- (instancetype)initWithProgramID:(NSInteger)programID;

- (void)requestDetailPoem:(void(^)(PoemDetailDataStruc *detailDataStruc))completionBlock;

@end
