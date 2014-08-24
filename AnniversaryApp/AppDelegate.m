//
//  AppDelegate.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-2.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "AppDelegate.h"
#import "RecordDAO.h"
#import "RecordCategoryDAO.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.operationQueue = [[NSOperationQueue alloc] init];
//    self.operationQueue.maxConcurrentOperationCount = 1;
    
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
    RecordCategoryDAO *categoryDAO = [[RecordCategoryDAO alloc] init];
    _categoryArray = [categoryDAO findAll];
    
    // 加入默认信息
    if ([_categoryArray count] == 0) {
        [_categoryArray addObject:[categoryDAO addRecordCategoryName:@"纪念日"]];
        [_categoryArray addObject:[categoryDAO addRecordCategoryName:@"生日"]];
    }
    
}

//- (void)saveCategory
//{
//    [self.operationQueue addOperationWithBlock:^{
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//        NSString *plistPath = [paths objectAtIndex:0];
//        NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedCategory.plist"];
//        
//        [self.categoryArray writeToFile:filename atomically:YES];
//        
//    }];
//}


- (void)loadRecordDate
{
    RecordDAO *recordDAO = [[RecordDAO alloc] init];
    _recordArray = [recordDAO findAll];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // 加入默认信息
    if ([_recordArray count] == 0) {
        [_recordArray addObject:[recordDAO addRecordTitle:@"纪念日" date:[dateFormatter dateFromString:@"2014-07-01"]  category:_categoryArray[0]]];
    }
    
}

//- (void)saveRecordData
//{
//    [self.operationQueue addOperationWithBlock:^{
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//        NSString *plistPath = [paths objectAtIndex:0];
//        NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedAnniversary.plist"];
//        
//        [self.recordDateDicArray writeToFile:filename atomically:YES];
//        
//    }];
//}

@end
