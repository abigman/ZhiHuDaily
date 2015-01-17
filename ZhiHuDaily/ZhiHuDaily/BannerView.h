//
//  BannerView.h
//  ZhiHuDaily
//
//  Created by 任龙宇 on 15/1/17.
//  Copyright (c) 2015年 renlongyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerViewDelegate <NSObject>
//触摸事件的回调
- (void)touchImageView:(NSInteger)index;

@end

@interface BannerView : UIView

@property (weak, nonatomic) id<BannerViewDelegate> delegate;
@property (assign, nonatomic) NSTimeInterval timeInterval;


- (id)initWithFrame:(CGRect)frame pageCount:(NSInteger)pageCount;

//从imageURL数组中加载图像, url为网络地址
- (void)loadImage:(NSArray *)imageUrlArray;

//设置滚动的事件间隔, 默认为5秒
- (void)setTimeInterval:(NSTimeInterval)timeInterval;

@end
