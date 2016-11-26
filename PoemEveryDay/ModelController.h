//
//  ModelController.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;
@class RootViewControllerVM;

@interface ModelController : NSObject <UIPageViewControllerDataSource>
@property (strong, nonatomic) NSArray *pageData;

- (instancetype)initWithRootViewModel:(RootViewControllerVM *)viewModel NS_DESIGNATED_INITIALIZER;

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

