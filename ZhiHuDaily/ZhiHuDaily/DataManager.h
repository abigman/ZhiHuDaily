//
//  DataManager.h
//  ZhiHuDaily
//
//  Created by 任龙宇 on 15/1/20.
//  Copyright (c) 2015年 renlongyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager *)manager;

- (void)requestDataFromServer:(void (^)(BOOL success))block;

//插入数据
- (void)insertCoreData:(NSMutableArray *)dataArray;

//删除数据
- (void)deleteCoreData;

//查询数据
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;

//更新数据
//- (void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook;

@end
