//
//  DataViewController.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewControllerVM;
@class CoverListDataStruc;

@interface DataViewController : UIViewController
@property (assign, nonatomic) NSInteger controllerIndex;

- (void)initilizeViewWithViewModel:(DataViewControllerVM *)vm;

@end

