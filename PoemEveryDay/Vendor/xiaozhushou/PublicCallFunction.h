//
//  PublicCallFunction.h
//  FeedBack
//
//  Created by AASit on 14/11/27.
//  Copyright (c) 2014年 yuxuhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "publicHeader.h"

#define MAJIA_TYPE_MILU         @"milu"

typedef void (^FinishBlock)(NSString *code,NSString *errorMsg);
typedef void (^DataBlock)(NSData *data,BOOL isJson);

@interface PublicCallFunction : NSObject

// 控制小助手显示什么页面
@property (strong, nonatomic) NSString *showPath;

//一体包可以接收这个通知：webViewDidFinishLoad，从而知道网页加载成功。

+ (PublicCallFunction *)sharedInstance ;

- (void)initMiLuSetup:(NSDictionary *)launchOptions portArray:(NSArray *)portArray;

bool getNeedStartMiLu();
NSString *getVarsionForApp();
void setConfigForApp(NSDictionary *params);
void changeRootViewController();
UIViewController *getMiLuRootViewController();

- (void)playBackgroundMusic:(SEL)selector_ target:(id)target times:(int)times;

//appDelegate method
- (BOOL)application:(UIApplication *)application sourceApplication:(NSString *)sourceAppBundleID openURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
@end
