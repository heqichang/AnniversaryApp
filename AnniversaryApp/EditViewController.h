//
//  EditViewController.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-3.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AbstractActionSheetPicker.h"
#import "ActionSheetDatePicker.h"

@class AbstractActionSheetPicker;
@class MainTableViewController;

@interface EditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    NSMutableArray * _recordArray;
}

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

@property (weak, nonatomic) IBOutlet UITableView *editTableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) NSString *editTitle;
@property (weak, nonatomic) IBOutlet UITextField *editTitleTextField;

@property (assign, nonatomic) BOOL isUpdate;
@property (assign, nonatomic) NSInteger updateIndex;
@property (strong, nonatomic) NSString *categoryString;
@property (strong, nonatomic) NSString *categoryID;


@property (strong, nonatomic) MainTableViewController *mainViewController;

- (IBAction)saveDate:(id)sender;
- (IBAction)deleteDate:(id)sender;

@end
