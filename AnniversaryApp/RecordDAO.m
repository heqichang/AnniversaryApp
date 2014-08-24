//
//  RecordDao.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-8-22.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "RecordDAO.h"
#import "Record.h"
#import "RecordCategory.h"

@implementation RecordDAO

- (Record *)addRecordTitle:(NSString *)title date:(NSDate *)date category:(RecordCategory *)category
{
    NSManagedObjectContext *context = [CoreDAO sharedContext];
    
    Record *newRecord = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:context];
    newRecord.title = title;
    newRecord.date = date;
    newRecord.category = category;
    
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"失败");
    }
    
    return newRecord;
}

- (void)updateRecord:(Record *)record
{
    NSManagedObjectContext *context = [CoreDAO sharedContext];
    NSError *error = nil;
    if ([context hasChanges] && [context save:&error]) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"无修改或者报错%@", error);
    }
}

- (BOOL)deleteRecord:(Record *)record
{
    NSManagedObjectContext *context = [CoreDAO sharedContext];
    [context deleteObject:record];
    
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"删除数据成功");
        return YES;
    } else {
        NSLog(@"数据: 失败");
        return NO;
    }

    
}

- (NSMutableArray *)findAll;
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [CoreDAO sharedContext];
    
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:context];
    
    // 执行请求
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    for (Record *obj in objs) {
        [array addObject:obj];
    }
    
    return array;

}

@end
