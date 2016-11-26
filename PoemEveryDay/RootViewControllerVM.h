//
//  RootViewControllerVM.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataViewControllerVM;

@interface RootViewControllerVM : NSObject
@property (nonatomic, copy) NSArray *coverListAry;

- (void)requestCoverList:(void(^)(NSArray *list))compeletionBlock;

- (DataViewControllerVM *)getDataVCViewModelWithIndex:(NSInteger)index;

@end
