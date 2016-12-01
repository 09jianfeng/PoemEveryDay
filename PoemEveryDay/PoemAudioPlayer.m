//
//  AudioPlayer.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/29.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "PoemAudioPlayer.h"
#import "FBKVOController.h"
#import "PublicCallFunction.h"

@interface PoemAudioPlayer()
@end

@implementation PoemAudioPlayer{
    NSInteger _programID;
    AVPlayer *_player;
    id _timeObserve;
    FBKVOController *_kvoController;
    NSURL *_audioURL;
}

#pragma mark - public
- (void)dealloc{
    [self removeObjectForPlayItem:_player.currentItem];
}

- (instancetype)initWithAudioURL:(NSURL *)audioURL{
    self = [super init];
    if (self) {
        _audioURL = audioURL;
        AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:audioURL];
        _player = [[AVPlayer alloc] initWithPlayerItem:songItem];
        self.playerStatus = PoemAudioPlayerStatusLoadingData;
        [self addObserForPlayItem:songItem];
        //后台线程播放
        [[PublicCallFunction sharedInstance] playBackgroundMusic:@selector(play) target:self times:600000];
    }
    return self;
}

- (instancetype)init{
    return [self initWithAudioURL:[NSURL URLWithString:@""]];
}

- (void)restart{
    [self removeObjectForPlayItem:_player.currentItem];
    
    AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:_audioURL];
    _player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    [self addObserForPlayItem:songItem];
    [self play];
}

- (void)play{
    
    if (self.playerStatus == PoemAudioPlayerStatusFail) {
        [self restart];
        return;
    }
    
    [_player play];
    self.playerStatus = PoemAudioPlayerStatusLoadingData;
    
    if (self.totalBuffer > [self.playTime floatValue]) {
        self.playerStatus = PoemAudioPlayerStatusPlaying;
    }
}

- (void)pause{
    [_player pause];
    self.playerStatus = PoemAudioPlayerStatusPaused;
}

#pragma mark - private
- (void)removeObjectForPlayItem:(AVPlayerItem *)songItem{
    if (_kvoController) {
        [_kvoController unobserve:songItem];
    }
    
    if (_timeObserve) {
        [_player removeTimeObserver:_timeObserve];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    _kvoController = KVOController;
    // observe clock date property
    [_kvoController observe:songItem keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(PoemAudioPlayer *audioPlayer, AVPlayerItem *songItem, NSDictionary *change) {
        
        switch (songItem.status) {
            case AVPlayerItemStatusReadyToPlay:
                audioPlayer.playerStatus = PoemAudioPlayerStatusPlaying;
                DDLogDebug(@"ready to play");
                
                break;
                
            case AVPlayerItemStatusUnknown:
                DDLogDebug(@"AVPlayerItemStatusUnknown to play");
                break;
                
            case AVPlayerItemStatusFailed:
                DDLogDebug(@"AVPlayerItemStatusFailed to play");
                audioPlayer.playerStatus = PoemAudioPlayerStatusFail;
                break;
                
            default:
                break;
        }
    }];
    
    [_kvoController observe:songItem keyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew block:^(PoemAudioPlayer *viewModel, AVPlayerItem *songItem, NSDictionary *change) {
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        viewModel.totalBuffer = totalBuffer;
        DDLogDebug(@"共缓冲%.2f",totalBuffer);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
}

- (void)playbackFinished:(NSNotification *)notice {
    DDLogDebug(@"finish play");
    self.playerStatus = PoemAudioPlayerStatusPaused;
}

@end
