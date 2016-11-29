//
//  AudioPlayer.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/29.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoemAudioPlayer : NSObject
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy) NSString *playTime;
@property (nonatomic, copy) NSString *playDuration;
@property (nonatomic, assign) CGFloat totalBuffer;

- (instancetype)initWithAudioURL:(NSURL *)audioURL NS_DESIGNATED_INITIALIZER;

- (void)restart;

- (void)play;

- (void)pause;

@end
