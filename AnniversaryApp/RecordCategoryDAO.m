//
//  RecordCategoryDAO.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-8-23.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "RecordCategoryDAO.h"
#import "RecordCategory.h"


@implementation RecordCategoryDAO

- (RecordCategory *)addRecordCategoryName:(NSString *)name
{
    NSManagedObjectContext *context = [CoreDAO sharedContext];
    
    RecordCategory *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"RecordCategory" inManagedObjectContext:context];
    newCategory.name = name;
    
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"失败");
    }
    
    return newCategory;
}

- (void)updateRecord:(RecordCategory *)category
{
    
}

- (BOOL)deleteRecord:(RecordCategory *)category
{
    NSManagedObjectContext *context = [CoreDAO sharedContext];
    [context deleteObject:category];
    
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"删除分类成功");
        return YES;
    } else {
        NSLog(@"分类: 失败");
        return NO;
    }
}

- (NSMutableArray *)findAll
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [CoreDAO sharedContext];
    
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"RecordCategory" inManagedObjectContext:context];
    
    // 执行请求
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    for (RecordCategory *obj in objs) {
        [array addObject:obj];
    }
    
    return array;
}

@end
