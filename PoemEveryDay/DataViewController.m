//
//  DataViewController.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/23.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "DataViewController.h"
#import "MBProgressHUD.h"
#import "DataViewControllerVM.h"
#import "CoverListDataStruc.h"
#import "UIImageView+WebCache.h"

@interface DataViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeigh;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) DataViewControllerVM *controllerVM;
@end

@implementation DataViewController

- (void)dealloc{
}

- (void)initilizeViewWithViewModel:(DataViewControllerVM *)vm{
    _controllerVM = vm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_dataObject.imageLink] placeholderImage:[UIImage imageNamed:@"poem_default"]];
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
