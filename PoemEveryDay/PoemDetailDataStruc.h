//
//  PoemDetailDataStruc.h
//  PoemEveryDay
//
//  Created by JFChen on 16/11/26.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoemDetailDataStruc : NSObject
// poem summary data
@property (nonatomic, copy)     NSString *imageLink;
@property (nonatomic, assign)     CGFloat imgHeighWidthRatio;
@property (nonatomic, copy)     NSString *headerTitle;
@property (nonatomic, copy)     NSString *reciterName;
@property (nonatomic, copy)     NSString *reciterIcon;
@property (nonatomic, copy)     NSString *reciterCareer;
@property (nonatomic, assign)   NSInteger programID;

// poem detail data
@property (nonatomic, copy)     NSString *musicLink;
@property (nonatomic, copy)     NSString *poemTitle;
@property (nonatomic, copy)     NSString *poemEnjoy;
@property (nonatomic, copy)     NSString *poemPictureEnjoy;
@property (nonatomic, copy)     NSString *poemmusicEnjoy;
@property (nonatomic, copy)     NSString *translator;
@property (nonatomic, copy)     NSString *original;
@property (nonatomic, copy)     NSString *author;

@end
