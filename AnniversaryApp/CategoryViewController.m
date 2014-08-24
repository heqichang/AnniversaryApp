//
//  CategoryViewController.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-14.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "CategoryViewController.h"
#import "AppDelegate.h"

#import "CategoryTableViewCell.h"
#import "CategoryNewTableViewCell.h"

#import "EditViewController.h"

#import "RecordCategory.h"
#import "RecordCategoryDAO.h"

@interface CategoryViewController ()
{
    AppDelegate * _delegate;
}

@end

@implementation CategoryViewController

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
    
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tableView.layer.cornerRadius = 4.0f;

    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 每个cell的高度是40
    CGFloat height = [_delegate.categoryArray count] * 40;
    self.tableViewHeightConstraint.constant = height + 40;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_delegate.categoryArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row < [_delegate.categoryArray count]) {
        NSString *cellIdentifier = @"CategoryCell";
        CategoryTableViewCell *categoryCell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        RecordCategory *category = _delegate.categoryArray[indexPath.row];
        
        categoryCell.categoryLabel.text = category.name;
        
        
        cell = categoryCell;
    } else {
        NSString *cellIdentifier = @"NewCategoryCell";
        CategoryNewTableViewCell *newCategoryCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

        newCategoryCell.categoryTextField.text = @"";
        newCategoryCell.parentTableView = self.tableView;
        
        cell = newCategoryCell;
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"%d", indexPath.row);
        RecordCategoryDAO *categoryDAO = [[RecordCategoryDAO alloc] init];
        BOOL deleted = [categoryDAO deleteRecord:_delegate.categoryArray[indexPath.row]];
        
        if (deleted) {
            [_delegate.categoryArray removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark UITableViewDelegate method

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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

#pragma mark action

- (IBAction)saveCategory:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.row < [_delegate.categoryArray count]) {
        [self.editViewController updateCategory:_delegate.categoryArray[indexPath.row]];
        [self.editViewController.editTableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"%d", indexPath.row);
}
@end
