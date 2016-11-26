//
//  PoemDetailViewController.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/24.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "PoemDetailViewController.h"
#import "PoemDetailViewControllerVM.h"

@interface PoemDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContentBase;
@property (strong, nonatomic) PoemDetailViewControllerVM *viewModel;
@end

@implementation PoemDetailViewController

- (void)initControllerWithViewModel:(PoemDetailViewControllerVM *)viewModel{
    _viewModel = viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - even

- (IBAction)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
