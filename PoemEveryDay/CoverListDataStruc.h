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
@property (nonatomic, copy)     NSString *imageLink;
@property (nonatomic, copy)     NSString *summary;
@property (nonatomic, copy)     NSString *title;
@property (nonatomic, copy)     NSString *reciterName;
@property (nonatomic, copy)     NSString *date;
@property (nonatomic, assign)   NSInteger programID;

@end
