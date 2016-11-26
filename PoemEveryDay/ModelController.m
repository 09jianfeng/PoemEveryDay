//
//  ModelController.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "ModelController.h"
#import "DataViewController.h"
#import "RootViewControllerVM.h"


@interface ModelController ()
@property (strong, nonatomic) RootViewControllerVM *rootViewModel;
@end

@implementation ModelController

- (instancetype)initWithRootViewModel:(RootViewControllerVM *)viewModel{
    self = [super init];
    if (self) {
        // Create the data model.
        _rootViewModel = viewModel;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithRootViewModel:[RootViewControllerVM new]];
    return self;
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    [dataViewController initilizeViewWithViewModel:[_rootViewModel getDataVCViewModelWithIndex:index]];
    dataViewController.controllerIndex = index;
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    return viewController.controllerIndex;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
