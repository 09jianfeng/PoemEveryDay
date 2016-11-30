//
//  PoemDetailViewControllerVM.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoemAudioPlayer.h"

@class CoverListDataStruc;
@class PoemDetailDataStruc;

@interface PoemDetailViewControllerVM : NSObject
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy) NSString *playTime;
@property (nonatomic, copy) NSString *playDuration;
@property (nonatomic, assign) PoemAudioPlayerStatus playerStatus;

- (instancetype)initWithProgramID:(NSInteger)programID;

- (void)requestDetailPoem:(void(^)(PoemDetailDataStruc *detailDataStruc))completionBlock;

- (void)playerAudioWithURL:(NSURL *)audioURL;

@end
