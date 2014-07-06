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

@interface EditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

@property (weak, nonatomic) IBOutlet UITableView *editTableView;

@property (weak, nonatomic) NSString *editTitle;
@property (weak, nonatomic) IBOutlet UITextField *editTitleTextField;

@property (assign, nonatomic) BOOL isUpdate;
@property (assign, nonatomic) NSInteger updateIndex;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) NSMutableArray *dateArray;

- (IBAction)saveDate:(id)sender;
- (IBAction)deleteDate:(id)sender;

@end
