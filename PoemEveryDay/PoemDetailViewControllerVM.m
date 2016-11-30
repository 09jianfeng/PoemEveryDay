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
#import "FBKVOController.h"
#import "PoemAudioPlayer.h"

@interface PoemDetailViewControllerVM()
@property (nonatomic, strong) FBKVOController *kvoController;
@end

@implementation PoemDetailViewControllerVM{
    NSInteger _programID;
    PoemAudioPlayer *_audioPlayer;
}

- (void)dealloc{
    DDLogDebug(@"PoemDetailViewControllerVM dealloc");
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
            completionBlock(nil);
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
    if (!_audioPlayer) {
        _audioPlayer = [[PoemAudioPlayer alloc] initWithAudioURL:audioURL];
        [_audioPlayer play];
        [self addObserer];
    }
    
    if (_playerStatus == PoemAudioPlayerStatusPlaying) {
        [self pause];
    }else{
        [self play];
    }
    
}

#pragma mark - kvo for audioPlayer
- (void)addObserer{
    _kvoController = [FBKVOController controllerWithObserver:self];
    [_kvoController observe:_audioPlayer keyPath:@"progress" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewControllerVM *observer, PoemAudioPlayer *object, NSDictionary<NSString *,id> * _Nonnull change) {
        observer.progress = object.progress;
    }];
    
    [_kvoController observe:_audioPlayer keyPath:@"playDuration" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewControllerVM *observer, PoemAudioPlayer *object, NSDictionary<NSString *,id> * _Nonnull change) {
        observer.playDuration = object.playDuration;
    }];
    
    [_kvoController observe:_audioPlayer keyPath:@"playTime" options:NSKeyValueObservingOptionNew block:^(PoemDetailViewControllerVM *observer, PoemAudioPlayer * object, NSDictionary<NSString *,id> * _Nonnull change) {
        observer.playTime = object.playTime;
    }];
    
    [_kvoController observe:_audioPlayer keyPath:@"playerStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(PoemDetailViewControllerVM *observer, PoemAudioPlayer * object, NSDictionary<NSString *,id> * _Nonnull change) {
        observer.playerStatus = object.playerStatus;
    }];
}

- (void)removeObserver{
    [_kvoController unobserve:_audioPlayer];
}

#pragma mark - play handle

- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"finish play");
}

- (void)pause{
    [_audioPlayer pause];
}

- (void)play{
    [_audioPlayer play];
}
@end
