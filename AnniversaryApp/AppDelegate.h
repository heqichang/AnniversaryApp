//
//  AppDelegate.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-2.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *recordDateDicArray;
@property (strong, nonatomic) NSMutableDictionary *categoryDict;

@property (strong, nonatomic) NSOperationQueue *operationQueue;

- (void)saveCategory;
- (void)saveRecordData;
@end
