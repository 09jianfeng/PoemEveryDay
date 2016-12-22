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
#import "GDTSplashAd.h"
#import "GDTMobInterstitial.h"

@interface RootViewController () <GDTSplashAdDelegate,GDTMobInterstitialDelegate>
@property (readonly, strong, nonatomic) ModelController *modelController;
@property (strong, nonatomic) RootViewControllerVM *rtViewModel;
@property (strong, nonatomic) MBProgressHUD *mbProgressHUD;

@property (strong, nonatomic) GDTSplashAd *splash;
@property(nonatomic, retain) GDTMobInterstitial *gdtInterstitial;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showInterstitial];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //开屏广告初始化---------
        _splash = [[GDTSplashAd alloc] initWithAppkey:@"1105125629" placementId:@"9030701809870589"];
        _splash.delegate = self;//设置代理
        //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
        if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
            _splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-568h"]];
        } else {
            _splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]];
        }
        UIWindow *fK = [[[UIApplication sharedApplication] delegate] window];
        //设置开屏拉取时长限制，若超时则不再展示广告
        _splash.fetchDelay = 10;
        //拉取并展示
        [_splash loadAdAndShowInWindow:fK];
        
        //广点通插屏
        self.gdtInterstitial = [[GDTMobInterstitial alloc] initWithAppkey:@"1105125629" placementId:@"5080308839373670"];
        self.gdtInterstitial.delegate = self;
        self.gdtInterstitial.isGpsOn = NO;
        [self.gdtInterstitial loadAd];
    });
}

- (void)showInterstitial{
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow]
                            rootViewController];
    
    if (_gdtInterstitial.isReady) {
        NSLog(@"广点通 ready了");
        [_gdtInterstitial presentFromRootViewController:vc];
    }else{
        NSLog(@"广点通 还没ready");
        [_gdtInterstitial loadAd];
    }
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

#pragma mark -
#pragma mark - 广点通开屏广告代理
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
}

-(void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"splashAdWillPresentFullScreen");
}

-(void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"splashADDidDismissFullScreenModal");
}

#pragma mark - 广点通插屏代理
static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Loaded.");
}

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded." );
}

/**
 *  插屏广告将要展示回调
 *  详解: 插屏广告即将展示回调该函数
 */
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present.");
}

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." );
}

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented.");
    [_gdtInterstitial loadAd];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background.");
}

/**
 *  插屏广告曝光时回调
 *  详解: 插屏广告曝光时回调
 */
-(void)interstitialWillExposure:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Exposured");
}
/**
 *  插屏广告点击时回调
 *  详解: 插屏广告点击时回调
 */
-(void)interstitialClicked:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Clicked");
}

@end
