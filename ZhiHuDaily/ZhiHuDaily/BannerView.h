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

//滚动的时间间隔, 默认为5秒
@property (assign, nonatomic) NSTimeInterval timeInterval;

//用户拖动的时候是否暂停计时器,默认为NO
@property (assign, nonatomic) BOOL stopScrollWhenDragging;

- (id)initWithFrame:(CGRect)frame pageCount:(NSInteger)pageCount;

//从imageURL数组中加载图像, url为网络地址
- (void)loadImage:(NSArray *)imageUrlArray placeholder:(UIImage *)plageholder;

@end
