//
//  LYCircleView.h
//  无线滚动
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYCircleView;

@protocol LYcircleViewDelegate <NSObject>

@required

- (NSInteger)numberOfContentViewsInCircleView:(LYCircleView *)circleView;

- (UIView *)circleView:(LYCircleView *)circleView contentViewAtIndex:(NSInteger)index;

@optional

- (void)circleView:(LYCircleView *)circleView currentContentViewAtIndex:(NSInteger)index;

- (void)circleView:(LYCircleView *)circleView didSelectContentViewAtIndex:(NSInteger)index;

@end

@interface LYCircleView : UIView
@property (nonatomic, weak)id<LYcircleViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)timeDuration;
@end
