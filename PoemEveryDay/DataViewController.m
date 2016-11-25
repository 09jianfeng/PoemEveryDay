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

@interface DataViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeigh;
@property (strong, nonatomic) DataViewControllerVM *dataViewConVM;
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addKVOObsever];
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

#pragma mark - kvo

- (void)addKVOObsever{
    [self addObserver:_dataViewConVM forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:_dataViewConVM forKeyPath:@"summary" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:_dataViewConVM forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:_dataViewConVM forKeyPath:@"reciter" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:_dataViewConVM forKeyPath:@"date" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVOObsever{
    [self removeObserver:_dataViewConVM forKeyPath:@"image"];
    [self removeObserver:_dataViewConVM forKeyPath:@"summary"];
    [self removeObserver:_dataViewConVM forKeyPath:@"title"];
    [self removeObserver:_dataViewConVM forKeyPath:@"reciter"];
    [self removeObserver:_dataViewConVM forKeyPath:@"date"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object != _dataViewConVM) {
        return;
    }
    
    
    
}


@end
