//
//  RootViewController.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "DataViewController.h"
#import "RootViewControllerVM.h"
#import "MBProgressHUD.h"
#import "FBKVOController.h"

@interface RootViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;
@property (strong, nonatomic) RootViewControllerVM *rtViewModel;
@property (strong, nonatomic) MBProgressHUD *mbProgressHUD;
@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _mbProgressHUD.detailsLabel.text = @"loading...";
    _mbProgressHUD.backgroundColor = [UIColor grayColor];
    [_mbProgressHUD showAnimated:YES];
    WeakSelf
    [self.rtViewModel requestCoverList:^(NSArray *list) {
        if (list) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf initSubViewController:list];
                [weakSelf.mbProgressHUD hideAnimated:YES];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
               _mbProgressHUD.detailsLabel.text = @"加载失败，请检查网络然后重试";
            });
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubViewController:(NSArray *)pageData{
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    self.modelController.pageData = pageData;
    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    }
    self.pageViewController.view.frame = pageViewRect;
    pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    
    [self.pageViewController didMoveToParentViewController:self];

}

#pragma mark - lazy load var

- (RootViewControllerVM *)rtViewModel{
    if (!_rtViewModel) {
        _rtViewModel = [RootViewControllerVM new];
    }
    
    return _rtViewModel;
}

- (ModelController *)modelController {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] initWithRootViewModel:self.rtViewModel];
    }
    return _modelController;
}


#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.pageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    DataViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


    return UIPageViewControllerSpineLocationMid;
}


@end
