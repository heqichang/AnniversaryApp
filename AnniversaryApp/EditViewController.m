//  EditViewController.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-3.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "EditViewController.h"
#import "MainTableViewController.h"
#import "ActionSheetDatePicker.h"
#import "CategoryViewController.h"
#import "EditCategoryTableViewCell.h"
#import "EditDateTableViewCell.h"
#import "AppDelegate.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _recordArray = delegate.recordDateDicArray;
    
    // 需初始化
    if (self.selectedDate == nil) {
        self.selectedDate = [NSDate date];
    }
    
    if (self.editTitle != nil) {
        self.editTitleTextField.text = self.editTitle;
    }
    
    // 为tableview添加border
    self.editTableView.layer.borderWidth = 1.0f;
    self.editTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.editTableView.layer.cornerRadius = 4.0f;
    
    // 修复ios7下cell的分割线左边总是不能抵达到头的问题
    // 参考：http://stackoverflow.com/questions/18773239/how-to-fix-uitableview-separator-on-ios-7
    if ([self.editTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.editTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (!self.isUpdate) {
        self.deleteButton.hidden = YES;
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView.tag == 1002) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"DateCell";
            EditDateTableViewCell *editCell = (EditDateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            editCell.dateLabel.text = [formatter stringFromDate:self.selectedDate];
            cell = editCell;
        }
        else if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"CategoryCell";
            EditCategoryTableViewCell *editCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (isEmpty(self.categoryString) == NO) {
                editCell.categoryLabel.text = self.categoryString;
            } else {
                self.categoryString = @"未分类";
                self.categoryID = @"0";
            }
            
            cell = editCell;
            
        }

    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        EditDateTableViewCell *cell = (EditDateTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:cell];
        [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
        self.actionSheetPicker.hideCancel = YES;
        [self.actionSheetPicker showActionSheetPicker];
    } else {
        
    }
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    
    EditDateTableViewCell *cell = (EditDateTableViewCell *)element;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    

    cell.dateLabel.text = [dateFormatter stringFromDate:self.selectedDate];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.editTitleTextField resignFirstResponder];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCategory"]) {
        CategoryViewController *categoryViewController = (CategoryViewController *)[segue destinationViewController];
        categoryViewController.editViewController = self;
    }
}


#pragma mark action

- (IBAction)saveDate:(id)sender {
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    
    if (self.isUpdate == NO) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.editTitleTextField.text forKey:@"title"];
        [dict setObject:[formatter stringFromDate:self.selectedDate] forKey:@"date"];
        [dict setObject:self.categoryString forKey:@"category"];
        [dict setObject:self.categoryID forKey:@"categoryID"];
        [_recordArray addObject:dict];
        

    } else {
        NSDictionary *dict = [_recordArray objectAtIndex:self.updateIndex];
        [dict setValue:self.editTitleTextField.text forKey:@"title"];
        [dict setValue:[formatter stringFromDate:self.selectedDate] forKey:@"date"];
        [dict setValue:self.categoryString forKey:@"category"];
        [dict setValue:self.categoryID forKey:@"categoryID"];
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate saveRecordData];
    
    // 这里对主界面进行reload，主界面就不会有延迟反应
    [self.mainViewController.tableView reloadData];
    // 返回主界面
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)deleteDate:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确认删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {

        [_recordArray removeObjectAtIndex:self.updateIndex];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate saveRecordData];
        
        [self.mainViewController.tableView reloadData];
        // 返回主界面
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

// 参考 http://stackoverflow.com/questions/899209/how-do-i-test-if-a-string-is-empty-in-objective-c
static inline BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

@end
