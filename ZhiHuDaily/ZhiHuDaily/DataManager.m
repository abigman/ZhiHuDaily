//
//  DataManager.m
//  ZhiHuDaily
//
//  Created by 任龙宇 on 15/1/20.
//  Copyright (c) 2015年 renlongyu. All rights reserved.
//

#import "DataManager.h"
#import <CoreData/CoreData.h>
#import "Story.h"
#import "AFHTTPRequestOperationManager.h"
#import "Model.h"


static NSString * const TableName = @"Story";

@interface DataManager ()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DataManager

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark -

+ (DataManager *)manager {
    return [[DataManager alloc] init];
}

#pragma mark -
- (void)requestDataFromServer:(void (^)(BOOL success))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseData:responseObject];
        block(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO);
    }];
}

- (void)parseData:(id)responseObject {
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in responseObject[@"stories"]) {
        Model *story = [[Model alloc] init];
        story.image = [dic[@"images"] firstObject];
        story.title = dic[@"title"];
        [dataArray addObject:story];
    }
    
    [self deleteCoreData];
    [self insertCoreData:dataArray];
}

#pragma mark -

- (NSURL *)applicationDocumentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            abort();
        }
    }
}

#pragma mark -

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ZhiHuDaily" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    return _managedObjectContext;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSURL *storeURL = [[self applicationDocumentsURL] URLByAppendingPathComponent:@"ZhiHuDaily.sqlite"];
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }
    return _persistentStoreCoordinator;
}

#pragma mark -

//插入数据
- (void)insertCoreData:(NSMutableArray *)dataArray {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    for (Story *story in dataArray) {
        Story *storyInfo = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:managedObjectContext];
        storyInfo.title = story.title;
        storyInfo.image = story.image;
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
        }
    }
}

//删除全部数据
- (void)deleteCoreData {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && datas.count) {
        for (NSManagedObject *obj in datas) {
            [context deleteObject:obj];
        }
        if (![context save:&error]) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
        }
    }
    
}

//查询数据
- (NSMutableArray *)selectData:(int)pageSize andOffset:(int)currentPage {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //限定查询结果的数量
    [request setFetchLimit:pageSize];
    //查询的偏移量
    [request setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (Story *story in datas) {
        Model *model = [[Model alloc] init];
        model.title = story.title;
        model.image = story.image;
        [array addObject:model];
    }
    return array;
}


@end
