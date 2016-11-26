//
//  DataViewControllerVM.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "DataViewControllerVM.h"
#import "WebRequest.h"
#import "PoemDetailViewControllerVM.h"

@implementation DataViewControllerVM

- (PoemDetailViewControllerVM *)getDetailViewModel{
    PoemDetailViewControllerVM *detailViewModel = [[PoemDetailViewControllerVM alloc] initWithProgramID:_dataObject.programID];
    return detailViewModel;
}

@end
