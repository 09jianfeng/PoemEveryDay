//
//  PoemDetailViewController.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/24.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PoemDetailViewControllerVM;

@interface PoemDetailViewController : UIViewController

- (void)initControllerWithViewModel:(PoemDetailViewControllerVM *)viewModel;

@end
