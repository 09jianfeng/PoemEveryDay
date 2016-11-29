//
//  UIViewScrollContain.m
//  PoemEveryDay
//
//  Created by 陈建峰 on 16/11/29.
//  Copyright © 2016年 陈建峰. All rights reserved.
//

#import "UIViewScrollContain.h"

@implementation UIViewScrollContain

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSArray *subViews = [self subviews];
    for (UIView *view in subViews) {
        // must convertPoint to subView
        CGPoint subViewPoint = [self convertPoint:point toView:view];
        if ([view pointInside:subViewPoint withEvent:event]) {
            UIView *targetView = [view hitTest:subViewPoint withEvent:event];
            return targetView;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end
