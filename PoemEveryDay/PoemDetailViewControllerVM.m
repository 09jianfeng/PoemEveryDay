//
//  PoemDetailViewControllerVM.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "PoemDetailViewControllerVM.h"
#import "WebRequest.h"
#import "PoemDetailDataStruc.h"
#import <AVFoundation/AVFoundation.h>
#import "FBKVOController.h"

@interface PoemDetailViewControllerVM()
@property (nonatomic, strong) FBKVOController *kvoController;
@end

@implementation PoemDetailViewControllerVM{
    NSInteger _programID;
    AVPlayer *_player;
    id _timeObserve;
}

- (void)dealloc{
    [self removeObjectForPlayItem:_player.currentItem];
}

- (instancetype)initWithProgramID:(NSInteger)programID{
    self = [super init];
    if (self) {
        _programID = programID;
    }
    return self;
}

- (void)requestDetailPoem:(void(^)(PoemDetailDataStruc *detailDataStruc))completionBlock{
    [WebRequest requestPoemDetailWithID:_programID compeletionBlock:^(NSDictionary *jsonDic) {
        if (!jsonDic) {
            return ;
        }
        
        PoemDetailDataStruc *dataStruc = [PoemDetailDataStruc new];
        dataStruc.author = jsonDic[@"data"][@"audio"][@"audioGps"][0][@"poetry"][@"authors"][@"author"];
        dataStruc.original = jsonDic[@"data"][@"audio"][@"audioGps"][0][@"poetry"][@"original"];
        dataStruc.translator = jsonDic[@"data"][@"audio"][@"audioGps"][0][@"poetry"][@"translator"];
        dataStruc.poemTitle = jsonDic[@"data"][@"audio"][@"audioGps"][0][@"poetry"][@"title"];
        dataStruc.headerTitle = jsonDic[@"data"][@"title"];
        dataStruc.poemEnjoy = jsonDic[@"data"][@"poemProgramPenjoys"][0][@"poetryEnjoy"];
        dataStruc.poemPictureEnjoy = jsonDic[@"data"][@"poemPicture"][@"imgNew"];
        dataStruc.reciterName = jsonDic[@"data"][@"poemProgramGuestVos"][0][@"gName"];
        dataStruc.reciterCareer = jsonDic[@"data"][@"poemProgramGuestVos"][0][@"typeName"];
        dataStruc.reciterIcon = jsonDic[@"data"][@"poemProgramGuestVos"][0][@"imgNew"];
        dataStruc.imageLink = jsonDic[@"data"][@"poemPicture"][@"imgNew"];
        
        CGFloat heigh = [jsonDic[@"data"][@"poemPicture"][@"imgHeight"] floatValue];
        CGFloat width = [jsonDic[@"data"][@"poemPicture"][@"imgWidth"] floatValue];
        dataStruc.imgHeighWidthRatio = heigh / width;
        
        dataStruc.musicLink = jsonDic[@"data"][@"audio"][@"audioNew"];
        
        completionBlock(dataStruc);
    }];
}

- (void)playerAudioWithURL:(NSURL *)audioURL{
    [self removeObjectForPlayItem:_player.currentItem];
    
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:audioURL];
    _player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    [self play];
    [self addObserForPlayItem:songItem];
}

#pragma mark - avplayer 

- (void)addObserForPlayItem:(AVPlayerItem *)songItem{
    WeakSelf
    _timeObserve = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(songItem.duration);
        if (current) {
            weakSelf.progress = current / total;
            weakSelf.playTime = [NSString stringWithFormat:@"%.f",current];
            weakSelf.playDuration = [NSString stringWithFormat:@"%.2f",total];
            DDLogDebug(@"progress %f - current:%@ - total:%@",weakSelf.progress,weakSelf.playTime,weakSelf.playDuration);
        }
    }];
    
    // create KVO controller with observer
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.kvoController = KVOController;
    // observe clock date property
    [self.kvoController observe:songItem keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewControllerVM *viewModel, AVPlayerItem *songItem, NSDictionary *change) {
        
        switch (songItem.status) {
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"ready to play");
                break;
                
            case AVPlayerItemStatusUnknown:
                NSLog(@"AVPlayerItemStatusUnknown to play");
                break;
                
            case AVPlayerItemStatusFailed:
                NSLog(@"AVPlayerItemStatusFailed to play");
                break;
                
            default:
                break;
        }
    }];
    
    [self.kvoController observe:songItem keyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewControllerVM *viewModel, AVPlayerItem *songItem, NSDictionary *change) {
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSLog(@"共缓冲%.2f",totalBuffer);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
}

- (void)removeObjectForPlayItem:(AVPlayerItem *)songItem{
    if (_kvoController) {
        [_kvoController unobserve:songItem];
    }
    
    if (_timeObserve) {
        [_player removeTimeObserver:_timeObserve];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - play handle

- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"finish play");
}

- (void)pause{
    [_player pause];
}

- (void)play{
    [_player play];
}

@end
