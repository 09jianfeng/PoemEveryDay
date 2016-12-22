//
//  BundleIDTrick.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/12/19.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "BundleIDTrick.h"
#import <objc/runtime.h>

@implementation BundleIDTrick

- (NSString *)m_bundleIdentifier{
    return @"com.music.clickmusic";
}

+ (void)bundleIDTrick{
    Method m1 = class_getInstanceMethod([NSBundle class],@selector(bundleIdentifier));
    Method m2 = class_getInstanceMethod([BundleIDTrick class], @selector(m_bundleIdentifier));
    method_exchangeImplementations(m1, m2);
}

@end
