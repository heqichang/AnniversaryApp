//
//  EditViewController.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-3.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "EditViewController.h"
#import "ActionSheetDatePicker.h"
#import "EditDateTableViewCell.h"

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
            static NSString *CellIdentifier = @"TestCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveDate:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedAnniversary.plist"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    
    if (self.isUpdate == NO) {
        if (self.dateArray == nil) {
            self.dateArray = [[NSMutableArray alloc] init];
        }
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.editTitleTextField.text forKey:@"Title"];
        [dict setObject:[formatter stringFromDate:self.selectedDate] forKey:@"Date"];
        
        [self.dateArray addObject:dict];
        

    } else {
        NSDictionary *dict = [self.dateArray objectAtIndex:self.updateIndex];
        [dict setValue:self.editTitleTextField.text forKey:@"Title"];
        [dict setValue:[formatter stringFromDate:self.selectedDate] forKey:@"Date"];
    }
    
    [self.dateArray writeToFile:filename atomically:YES];

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
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedAnniversary.plist"];
        
        [self.dateArray removeObjectAtIndex:self.updateIndex];
        [self.dateArray writeToFile:filename atomically:YES];
        
        // 返回主界面
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
