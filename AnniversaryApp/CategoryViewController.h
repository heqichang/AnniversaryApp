//
//  CategoryViewController.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-14.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditViewController;

@interface CategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


// 通过约束在运行时动态tableview的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) EditViewController *editViewController;


- (IBAction)saveCategory:(id)sender;
@end
