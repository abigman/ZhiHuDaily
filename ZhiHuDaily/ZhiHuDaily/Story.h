//
//  Story.h
//  ZhiHuDaily
//
//  Created by 任龙宇 on 15/1/20.
//  Copyright (c) 2015年 renlongyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Story : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;

@end
