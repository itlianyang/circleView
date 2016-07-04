//
//  LYCircleView.m
//  无线滚动
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 mac. All rights reserved.
//


#import "LYCircleView.h"
@interface LYCircleView () <UIScrollViewDelegate>
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, assign)NSUInteger totalPageCount;
@property (nonatomic, assign)NSInteger currentPageIndex;
@property (nonatomic, assign)NSTimeInterval animationInterval;
@property (nonatomic, weak)UIPageControl *pageContral;
@end

@implementation LYCircleView
- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)timeDuration{
    self = [super initWithFrame:frame];
    if (self) {
        _animationInterval = timeDuration;
        [self addTimer];
        [self initScrollView];
        
    }
    return self;
}
#pragma mark - 设置代理
- (void)setDelegate:(id<LYcircleViewDelegate>)delegate{
    _delegate = delegate;
    
    [self reloadData];
}

#pragma mark - 刷新数据源
- (void)reloadData{
    _currentPageIndex  = 0;
    _totalPageCount    = 0;
    
    if ([self.delegate respondsToSelector:@selector(numberOfContentViewsInCircleView:)]) {
        _totalPageCount = [self.delegate numberOfContentViewsInCircleView:self];
    }
    [self addPageContrals];
    [self resetContentViews];
}
- (void)addPageContrals{
    
    UIPageControl *pagecontal = [[UIPageControl alloc] init];
    pagecontal.pageIndicatorTintColor = [UIColor redColor];
    pagecontal.currentPageIndicatorTintColor = [UIColor greenColor];
    CGFloat pageContralY = self.frame.size.height - 10;
    pagecontal.center = CGPointMake(self.center.x, pageContralY);
    //pagecontal.frame = CGRectMake(self.center.x, pageContralY, 100, 100);
    pagecontal.numberOfPages = self.totalPageCount;
    [self addSubview:pagecontal];
    _pageContral = pagecontal;
}
//初始化scrollView
- (void)initScrollView{
    UIScrollView *tmpScrollView = [[UIScrollView alloc] init];
    tmpScrollView.pagingEnabled  = YES;
    tmpScrollView.frame = self.frame;
    tmpScrollView.contentSize = CGSizeMake(self.frame.size.width *3, self.frame.size.height);
    tmpScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    tmpScrollView.delegate = self;
    
    _scrollView = tmpScrollView;
    [self addSubview:tmpScrollView];
}
//完成滚动重新设置下contentSize 的位置实现无线滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * self.frame.size.width)) {
        _currentPageIndex = [self getNextPageIndexWithCurrentPageIndex:_currentPageIndex];
        
        // 调用代理函数 当前页面序号
        if ([self.delegate respondsToSelector:@selector(circleView:currentContentViewAtIndex:)]) {
            [self.delegate circleView:self currentContentViewAtIndex:_currentPageIndex];
        }
        [self resetContentViews];
    }
    
    if(contentOffsetX <= 0) {
        _currentPageIndex = [self getPreviousPageIndexWithCurrentPageIndex:_currentPageIndex];
        
        // 调用代理函数 当前页面序号
        if ([self.delegate respondsToSelector:@selector(circleView:currentContentViewAtIndex:)]) {
            [self.delegate circleView:self currentContentViewAtIndex:_currentPageIndex];
        }
        
        [self resetContentViews];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}
#pragma mark - Methods
- (void)resetContentViews{
    // 移除scrollView上的所有子视图
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger previousPageIndex = [self getPreviousPageIndexWithCurrentPageIndex:_currentPageIndex];
    NSInteger currentPageIndex  = _currentPageIndex;
    NSInteger nextPageIndex     = [self getNextPageIndexWithCurrentPageIndex:_currentPageIndex];
    
    UIView * previousContentView;
    UIView * currentContentView;
    UIView * nextContentView;
    
    if ([self.delegate respondsToSelector:@selector(circleView:contentViewAtIndex:)]) {
        
        previousContentView = [self.delegate circleView:self contentViewAtIndex:previousPageIndex];
        currentContentView  = [self.delegate circleView:self contentViewAtIndex:currentPageIndex];
        nextContentView     = [self.delegate circleView:self contentViewAtIndex:nextPageIndex];
        
        NSArray * viewsArr = @[previousContentView ,currentContentView,nextContentView];
        
        for (int i = 0; i < viewsArr.count; i++) {
            UIView * contentView = viewsArr[i];
            
            [contentView setFrame:CGRectMake(self.frame.size.width*i, 0, contentView.frame.size.width, contentView.frame.size.height)];
            contentView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
            [contentView addGestureRecognizer:tapGesture];
            
            [self.scrollView addSubview:contentView];
        }
        
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
        self.pageContral.currentPage = currentPageIndex;
    }
}

// 获取当前页上一页的序号
- (NSInteger)getPreviousPageIndexWithCurrentPageIndex:(NSInteger)currentIndex{
    if (currentIndex == 0) {
        return _totalPageCount -1;
    }else{
        return currentIndex -1;
    }
}

// 获取当前页下一页的序号
- (NSInteger)getNextPageIndexWithCurrentPageIndex:(NSInteger)currentIndex{
    if (currentIndex == _totalPageCount -1) {
        return 0;
    }else{
        return currentIndex +1;
    }
}


#pragma mark - 点击事件
- (void)tapContentView:(UITapGestureRecognizer *)gesture{
    
    if ([self.delegate respondsToSelector:@selector(circleView:didSelectContentViewAtIndex:)]) {
        [self.delegate circleView:self didSelectContentViewAtIndex:_currentPageIndex];
    }
}
#pragma 添加定时器
- (void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:_animationInterval target:self selector:@selector(startScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)deleteTimer{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 当手动滑动时 删除定时器
    [self deleteTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 当手动滑动结束时 添加定时器
    [self addTimer];
}
#pragma 实现定时器切换到下一张单图片
- (void)startScroll{

    CGFloat contentOffsetX = _scrollView.contentOffset.x + self.frame.size.width;
    CGPoint newOffset = CGPointMake(contentOffsetX, 0);
    [_scrollView setContentOffset:newOffset animated:YES];

}
@end
