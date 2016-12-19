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
#import "UIImageView+WebCache.h"
#import "FBKVOController.h"

@interface PoemDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContentBase;
@property (strong, nonatomic) PoemDetailViewControllerVM *viewModel;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

//UI outlet
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *poemHeader;
@property (weak, nonatomic) IBOutlet UIImageView *poemImg;
@property (weak, nonatomic) IBOutlet UIImageView *reciterIcon;
@property (weak, nonatomic) IBOutlet UILabel *reciterName;
@property (weak, nonatomic) IBOutlet UILabel *reciterCareer;
@property (weak, nonatomic) IBOutlet UILabel *poemName;
@property (weak, nonatomic) IBOutlet UILabel *poemAuthor;
@property (weak, nonatomic) IBOutlet UITextView *poemTextView;
@property (weak, nonatomic) IBOutlet UILabel *poemEnjoy;
@property (weak, nonatomic) IBOutlet UILabel *poemEnjoyAuthor;
@property (weak, nonatomic) IBOutlet UITextView *poemEnjoyTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayAudio;
@property (weak, nonatomic) IBOutlet UIProgressView *progressAudio;
@property (weak, nonatomic) IBOutlet UILabel *labelProgressTime;
@property (copy, nonatomic) NSString *totalTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

// constrain
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poemHeighContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poemEnjoyHeighContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poemPictureHeigh;

@property (assign, nonatomic) CGFloat hwRatio;
@property (copy, nonatomic) NSString *audioURLString;
@end

@implementation PoemDetailViewController{
    FBKVOController *_kvoController;
}


- (void)dealloc{
    DDLogDebug(@"PoemDetailViewController dealloc");
    [self removeObser];
}

- (void)initControllerWithViewModel:(PoemDetailViewControllerVM *)viewModel{
    _viewModel = viewModel;
    _totalTime = @"00:00";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_btnPlay setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [_btnBack setImage:[UIImage imageNamed:@"poem_back_btn"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _hwRatio = 1.2;
    
    _reciterIcon.layer.cornerRadius = CGRectGetWidth(_reciterIcon.frame)/2.0;
    _reciterIcon.layer.masksToBounds = YES;
    
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_progressHUD showAnimated:YES];
    [_viewModel requestDetailPoem:^(PoemDetailDataStruc *detailDataStruc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_progressHUD hideAnimated:YES];
            _poemHeader.text = detailDataStruc.headerTitle;
            [_poemImg sd_setImageWithURL:[NSURL URLWithString:detailDataStruc.imageLink] placeholderImage:[UIImage imageNamed:@"poem_default"]];
            [_reciterIcon sd_setImageWithURL:[NSURL URLWithString:detailDataStruc.reciterIcon] placeholderImage:[UIImage imageNamed:@"poem_default"]];
            _reciterName.text = detailDataStruc.reciterName;
            _reciterCareer.text = detailDataStruc.reciterCareer;
            _poemName.text = detailDataStruc.poemTitle;
            _poemAuthor.text = [NSString stringWithFormat:@"作者：%@",detailDataStruc.author];
            _poemEnjoyAuthor.text = detailDataStruc.translator;
            
            _poemTextView.text = detailDataStruc.original;
            _poemEnjoyTextView.text = detailDataStruc.poemEnjoy;
            _hwRatio = detailDataStruc.imgHeighWidthRatio;
            _audioURLString = detailDataStruc.musicLink;
            
            [self.view setNeedsUpdateConstraints];
            [self.view setNeedsLayout];
        });
    }];
    
    [self UIKVOUpdate];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    CGFloat poemHeigh = [self getHeightForString:_poemTextView.text width:_poemTextView.frame.size.width font:[UIFont systemFontOfSize:15]];
    CGFloat poemEnjoyHeigh = [self getHeightForString:_poemEnjoyTextView.text width:_poemEnjoyTextView.frame.size.width font:[UIFont systemFontOfSize:15]];
    _poemHeighContrain.constant = poemHeigh;
    _poemEnjoyHeighContrain.constant = poemEnjoyHeigh;
    
    CGFloat picWidth = self.view.frame.size.width - 40;
    _poemPictureHeigh.constant = picWidth * _hwRatio;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat viewHeigh = _poemEnjoyTextView.frame.origin.y + _poemEnjoyTextView.frame.size.height;
    [_scrollViewContentBase setContentSize:CGSizeMake(_scrollViewContentBase.frame.size.width, viewHeigh)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIKVO

- (void)UIKVOUpdate{
    _kvoController = [FBKVOController controllerWithObserver:self];
    [_kvoController observe:_viewModel keyPath:@"progress" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewController *observer, PoemDetailViewControllerVM *object, NSDictionary<NSString *,id> * _Nonnull change) {
        observer.progressAudio.progress = object.progress;
    }];
    
    [_kvoController observe:_viewModel keyPath:@"playDuration" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewController *observer, PoemDetailViewControllerVM *object, NSDictionary<NSString *,id> * _Nonnull change) {
        int total = [object.playDuration intValue];
        observer.totalTime = [NSString stringWithFormat:@"%02d:%02d",total/60,total%60];
        
        int current  = [object.playTime intValue];
        observer.labelProgressTime.text = [NSString stringWithFormat:@"%02d:%02d/%@",current/60,current%60,observer.totalTime];
    }];
    
    [_kvoController observe:_viewModel keyPath:@"playTime" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewController *observer, PoemDetailViewControllerVM *object, NSDictionary<NSString *,id> * _Nonnull change) {
        int current  = [object.playTime intValue];
        observer.labelProgressTime.text = [NSString stringWithFormat:@"%02d:%02d/%@",current/60,current%60,observer.totalTime];
    }];
    
    [_kvoController observe:_viewModel keyPath:@"playerStatus" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewController *observer, PoemDetailViewControllerVM *object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (object.playerStatus == PoemAudioPlayerStatusPlaying) {
            [observer.btnPlay setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
        }else{
            [observer.btnPlay setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        }
    }];
}

- (void)removeObser{
    [_kvoController unobserve:_viewModel];
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

- (IBAction)btnPlayAudioPressed:(id)sender {
    [_viewModel playerAudioWithURL:[NSURL URLWithString:_audioURLString]];
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
