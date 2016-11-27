//
//  PoemDetailViewController.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/24.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "PoemDetailViewController.h"
#import "PoemDetailViewControllerVM.h"
#import "MBProgressHUD.h"
#import "PoemDetailDataStruc.h"
#import "Masonry.h"

@interface PoemDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContentBase;
@property (strong, nonatomic) PoemDetailViewControllerVM *viewModel;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@end

@implementation PoemDetailViewController

- (void)initControllerWithViewModel:(PoemDetailViewControllerVM *)viewModel{
    _viewModel = viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_progressHUD showAnimated:YES];
    [_viewModel requestDetailPoem:^(PoemDetailDataStruc *detailDataStruc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_progressHUD hideAnimated:YES];
        });
    }];
}

- (void)autoLayoutSubViews{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)getHeightForString:(NSString *)string width:(CGFloat)width font:(UIFont *)font{
    CGRect stringRect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return stringRect.size.height;
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
