//
//  DataViewController.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "DataViewController.h"
#import "MBProgressHUD.h"
#import "WebRequest.h"
#import "CocoaLumberjack.h"

@interface DataViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeigh;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebRequest requestCoverListData:^(NSDictionary *jsonDic) {
       dispatch_async(dispatch_get_main_queue(), ^{
           DDLogDebug(@"%@",jsonDic);
           [MBProgressHUD hideHUDForView:self.view animated:YES];
       });
    }];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    _imageViewHeigh.constant = CGRectGetWidth(self.view.frame) - 56;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.dataLabel.text = [self.dataObject description];
}


@end
