//
//  DataViewControllerVM.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoverListDataStruc.h"

@class PoemDetailViewControllerVM;

@interface DataViewControllerVM : NSObject
@property (strong, nonatomic) CoverListDataStruc *dataObject;

- (PoemDetailViewControllerVM *)getDetailViewModel;

@end
