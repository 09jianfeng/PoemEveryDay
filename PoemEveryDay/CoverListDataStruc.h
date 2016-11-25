//
//  CoverListDataStruc.h
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/25.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoverListDataStruc : NSObject

// poem summary data
@property (nonatomic, strong)   UIImage *imageLink;
@property (nonatomic, copy)     NSString *summary;
@property (nonatomic, copy)     NSString *title;
@property (nonatomic, copy)     NSString *reciterName;
@property (nonatomic, copy)     NSString *reciterIcon;
@property (nonatomic, copy)     NSString *reciterTitle;
@property (nonatomic, copy)     NSString *date;
@property (nonatomic, assign)   NSInteger programID;

// poem detail data
@property (nonatomic, copy)     NSString *musicLink;
@property (nonatomic, copy)     NSString *poemEnjoy;
@property (nonatomic, copy)     NSString *poemEnjoyEditor;
@property (nonatomic, copy)     NSString *poemPictureEnjoy;
@property (nonatomic, copy)     NSString *poemmusicEnjoy;

@end
