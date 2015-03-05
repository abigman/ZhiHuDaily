//
//  BannerView.m
//  ZhiHuDaily
//
//  Created by 任龙宇 on 15/1/17.
//  Copyright (c) 2015年 renlongyu. All rights reserved.
//

#import "BannerView.h"
#import "AppMacro.h"

@interface BannerView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger pageCount;
@property (strong, nonatomic) NSTimer *timer;

@end


@implementation BannerView

- (id)initWithFrame:(CGRect)frame pageCount:(NSInteger)pageCount {
    self = [super initWithFrame:frame];
    if (self) {
        _pageCount = pageCount;
        
        _timeInterval = 5;
        
        _stopScrollWhenDragging = NO;
        
        [self scrollView];
        
        [self imageViews];
        
        [self pageControl];
        
        [self startTimer];
    }
    return self;
}

- (void)loadImage:(NSArray *)imageUrlArray placeholder:(UIImage *)plageholder{
    for (int i = 1; i <= _pageCount; i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:100 + i];
        imageView.backgroundColor = RANDOM_COLOR;
    }
    
    UIImageView *firstImageView = (UIImageView *)[self viewWithTag:100];
    UIImageView *lastImageView = (UIImageView *)[self viewWithTag:100 + _pageCount + 1];
    
    firstImageView.backgroundColor = [self viewWithTag:100 + _pageCount].backgroundColor;
    lastImageView.backgroundColor = [self viewWithTag:100 + 1].backgroundColor;
}

#pragma mark - Accessor

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * (_pageCount + 2), self.frame.size.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)imageViews {
    for (int i = 0; i < _pageCount + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.tag = 100 + i;
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 100, 30)];
        label.text = [NSString stringWithFormat:@"%d", i];
        [imageView addSubview:label];
    }
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10, 0, 0)];
        _pageControl.center = CGPointMake(self.center.x, _pageControl.frame.origin.y);
        _pageControl.numberOfPages = _pageCount;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    [self stopTimer];
    [self startTimer];
}

#pragma mark - Timer

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
}

#pragma mark - Action

- (void)nextPage {
    NSInteger nextPage = _pageControl.currentPage + 1 + 1;
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width * nextPage, 0) animated:YES];

    if (nextPage == _pageCount + 1) {
        nextPage = 1;
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    _pageControl.currentPage = nextPage - 1;
}

- (void)touch:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 100;
    [_delegate touchImageView:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_stopScrollWhenDragging) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = _scrollView.contentOffset.x / self.frame.size.width;
    
    if (page == 0) {
        page = _pageCount;
    }
    
    if (page == _pageCount + 1) {
        page = 1;
    }
    
    scrollView.contentOffset = CGPointMake(self.frame.size.width * page, 0);
    _pageControl.currentPage = page - 1;
    
    if (_stopScrollWhenDragging) {
        [self startTimer];
    }
}


@end
