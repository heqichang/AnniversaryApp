//
//  MainTableViewController.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-3.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableViewCell.h"

#import "EditViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // NSBundle获取的资源文件无法修改
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *path = [bundle pathForResource:@"SavedAnniversary" ofType:@"plist"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"SavedAnniversary.plist"];
    
    if (dateArray == nil) {
        dateArray = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    }
    
    if (dateArray == nil) {
        dateArray = [[NSMutableArray alloc] init];
    }
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //NSLog(@"%@", dateArray);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return dateArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"cell";
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *data = [dateArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [data objectForKey:@"Title"];
    cell.dateLabel.text = [data objectForKey:@"Date"];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *past = [formatter dateFromString:[data objectForKey:@"Date"]];
    
    NSTimeInterval distance = [past timeIntervalSinceNow];
    NSInteger iDat = distance / ( 86400 ) ;
    NSString *distanceString = [NSString stringWithFormat:@"%d", abs(iDat)];
    
    if (iDat < 0) {
        cell.daysLabel.textColor = [UIColor blueColor];
    } else {
        
    }
    cell.daysLabel.text = distanceString;
    
    cell.index = indexPath.row;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MainTableViewCell *cell = (MainTableViewCell *)sender;
    if ([[segue identifier] isEqualToString:@"ShowUpdate"]) {
        EditViewController *controller = (EditViewController *)[segue destinationViewController];
        controller.editTitle = cell.titleLabel.text;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        controller.selectedDate = [formatter dateFromString:cell.dateLabel.text];
        
        controller.isUpdate = YES;
        controller.updateIndex = cell.index;
        controller.dateArray = dateArray;
    }
    else if([[segue identifier] isEqualToString:@"ShowAdd"]) {
        EditViewController *controller = (EditViewController *)[segue destinationViewController];
        controller.dateArray = dateArray;
    }
}


@end
