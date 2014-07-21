//
//  CategoryMenuTableViewController.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-21.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTableViewController;

@interface CategoryMenuTableViewController : UITableViewController
{
    NSMutableDictionary * _categoryDict;
    NSArray * _dictKeys;
}

@property(nonatomic,assign) MainTableViewController *delegate;
@end
