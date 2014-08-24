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

#import "Record.h"
#import "RecordDAO.h"
#import "RecordCategory.h"

@interface EditViewController ()
{
    NSDate * _updatedDate;
    AppDelegate * _delegate;
}
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
    _delegate = delegate;
    
    // 为tableview添加border
    self.editTableView.layer.borderWidth = 1.0f;
    self.editTableView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.editTableView.layer.cornerRadius = 4.0f;
    
    // 修复ios7下cell的分割线左边总是不能抵达到头的问题
    // 参考：http://stackoverflow.com/questions/18773239/how-to-fix-uitableview-separator-on-ios-7
    if ([self.editTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.editTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // 需初始化
    // 如果是更新数据的话，将显示删除按钮
    if (_record) {
        _editTitleTextField.text = _record.title;
        _recordCategory = _record.category;
    } else {
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
            
            _updatedDate = [NSDate date];
            
            if (_record) {
                _updatedDate = _record.date;
            }
            
            editCell.dateLabel.text = [formatter stringFromDate:_updatedDate];
            cell = editCell;
        }
        else if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"CategoryCell";
            EditCategoryTableViewCell *editCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (isEmpty(_recordCategory.name)) {
                editCell.categoryLabel.text = @"未分类";
            } else {
                editCell.categoryLabel.text = _recordCategory.name;
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
        NSDate *date = [NSDate date];
        
        if (_record) {
            date = _record.date;
        }
        
        _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:date target:self action:@selector(dateWasSelected:element:) origin:cell];
        [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
        self.actionSheetPicker.hideCancel = YES;
        [self.actionSheetPicker showActionSheetPicker];
    } else {
        
    }
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    _updatedDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    EditDateTableViewCell *cell = (EditDateTableViewCell *)element;
    cell.dateLabel.text = [dateFormatter stringFromDate:_updatedDate];
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

- (void)updateCategory:(RecordCategory *)category
{
    _recordCategory = category;
}


#pragma mark action

- (IBAction)saveDate:(id)sender {
    
    RecordDAO *recordDAO = [[RecordDAO alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    
    if (_record) {
        _record.title = _editTitleTextField.text;
        _record.date = _updatedDate;
        _record.category = _recordCategory;
        [recordDAO updateRecord:_record];
    } else {
        [_delegate.recordArray addObject:[recordDAO addRecordTitle:_editTitleTextField.text date:_updatedDate category:_recordCategory]];
    }
    
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
        
        RecordDAO *recordDAO = [[RecordDAO alloc] init];
        BOOL deleted = [recordDAO deleteRecord:_record];
        
        if (deleted) {
            [_delegate.recordArray removeObject:_record];
        }
        
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
