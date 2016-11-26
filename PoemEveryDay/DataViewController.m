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
#import "PoemDetailViewController.h"
#import "FBKVOController.h"

@interface DataViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeigh;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *labReciter;
@property (strong, nonatomic) DataViewControllerVM *viewModel;
@property (strong, nonatomic) CoverListDataStruc *dataObject;

@property (strong, nonatomic) FBKVOController *kvoController;
@end

@implementation DataViewController

- (void)dealloc{
}

- (void)initilizeViewWithViewModel:(DataViewControllerVM *)vm{
    _viewModel = vm;
    _dataObject = vm.dataObject;
    
    // create KVO controller with observer
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.kvoController = KVOController;
    
//    // observe clock date property
//    [self.kvoController observe:_controllerVM keyPath:@"dataObject" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(DataViewController *viewController, DataViewControllerVM *viewModel, NSDictionary *change) {
//        
//        // update clock view with new value
//        viewController.dataObject = viewModel.dataObject;
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_dataObject.imageLink] placeholderImage:[UIImage imageNamed:@"poem_default"]];
    _labTitle.text = _dataObject.title;
    _labAuthor.text = _dataObject.summary;
    _labDate.text = _dataObject.date;
    _labReciter.text = [NSString stringWithFormat:@"%@为你读诗",_dataObject.reciterName];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    PoemDetailViewController *poemDetailVC = [segue destinationViewController];
    [poemDetailVC initControllerWithViewModel:[_viewModel getDetailViewModel]];
}


@end
