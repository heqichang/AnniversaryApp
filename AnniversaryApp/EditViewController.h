//
//  EditViewController.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-3.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RecordCategory;
@class Record;
@class AbstractActionSheetPicker;
@class MainTableViewController;

@interface EditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

@property (weak, nonatomic) IBOutlet UITableView *editTableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (weak, nonatomic) IBOutlet UITextField *editTitleTextField;

@property (assign, nonatomic) BOOL isUpdate;


@property (weak, nonatomic) Record *record;
@property (weak, nonatomic) RecordCategory *recordCategory;


@property (strong, nonatomic) MainTableViewController *mainViewController;

- (void)updateCategory:(RecordCategory *)category;
- (IBAction)saveDate:(id)sender;
- (IBAction)deleteDate:(id)sender;

@end
