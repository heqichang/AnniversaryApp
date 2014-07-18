//
//  AppDelegate.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-2.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    // 加载类别
    [self loadCategory];
    
    // 加载记录的日期
    [self loadRecordDate];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark user defined

- (void)loadCategory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedCategory.plist"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    BOOL isExist = [fileManager fileExistsAtPath:filename];
    
    // 加入默认信息
    if (isExist == NO) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"未分类", @"name", @"0", @"id", nil];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"纪念日", @"name", @"1", @"id", nil];
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"生日", @"name", @"2", @"id", nil];
        [array addObject:dic];
        [array addObject:dic1];
        [array addObject:dic2];
        
        [array writeToFile:filename atomically:YES];
    }
    
    self.categoryArray = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    assert(self.categoryArray != nil);
    
    self.categoryDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    for (NSDictionary *dict in self.categoryArray) {
        [self.categoryDict setObject:[dict objectForKey:@"name"] forKey:[dict objectForKey:@"id"]];
    }
}

- (void)saveCategory
{
    [self.operationQueue addOperationWithBlock:^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedCategory.plist"];
        
        [self.categoryArray writeToFile:filename atomically:YES];
        
    }];
}


- (void)loadRecordDate
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedAnniversary.plist"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    BOOL isExist = [fileManager fileExistsAtPath:filename];
    
    // 加入默认信息
    if (isExist == NO) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
        [dic1 setObject:@"纪念日" forKey:@"title"];
        [dic1 setObject:@"2014-07-15" forKey:@"date"];
        [dic1 setObject:@"纪念日" forKey:@"category"];
        [dic1 setObject:@"1" forKey:@"categoryID"];
        
        [array addObject:dic1];
        [array writeToFile:filename atomically:YES];
    }
    
    self.recordDateDicArray = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    
    assert(self.recordDateDicArray != nil);
}

- (void)saveRecordData
{
    [self.operationQueue addOperationWithBlock:^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedAnniversary.plist"];
        
        [self.recordDateDicArray writeToFile:filename atomically:YES];
        
    }];
}

@end
