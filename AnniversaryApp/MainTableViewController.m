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
#import "AppDelegate.h"

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

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    //[self.tableView reloadData];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // NSBundle获取的资源文件无法修改
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *path = [bundle pathForResource:@"SavedAnniversary" ofType:@"plist"];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _recordArray = delegate.recordDateDicArray;
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;
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
    return _recordArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"cell";
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *data = [_recordArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [data objectForKey:@"title"];
    cell.dateLabel.text = [data objectForKey:@"date"];
    
    
    // 有个方法 timeIntervalSinceNow 但不正确，如果正好设置前一天或者后一天显示有误
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *past = [formatter dateFromString:[data objectForKey:@"date"]];
    NSDate *now = [NSDate date];
    now = [formatter dateFromString:[formatter stringFromDate:now]];
    NSTimeInterval distance = [past timeIntervalSinceDate:now];
    NSInteger iDat = distance / ( 86400 ) ;
    NSString *distanceString = [NSString stringWithFormat:@"%d", (iDat < 0 ? -1 * iDat : iDat)];
    
    if (iDat <= 0) {
        
        // 使用 NSMutableAttributedString 可以实现在同一个UILabel中不同的font,size等特性。
        // 但是貌似不能在同一个 NSMutableAttributedString里设置不同的font，需要init多个，然后append在一起
        // 参考: http://stackoverflow.com/questions/15646149/uilabel-with-different-fonts
        // http://stackoverflow.com/questions/1417346/iphone-uilabel-containing-text-with-multiple-fonts-at-the-same-time
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"已过"];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:10.0] range:NSMakeRange(0, 2)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:distanceString];
        [attributedString1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"American Typewriter" size:15.0] range:NSMakeRange(0, distanceString.length)];
        [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, distanceString.length)];
        [attributedString appendAttributedString:attributedString1];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"天"];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:10.0] range:NSMakeRange(0, 1)];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 1)];
        [attributedString appendAttributedString:attributedString2];
        
        cell.daysLabel.attributedText = attributedString;
    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"还有"];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:10.0] range:NSMakeRange(0, 2)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 2)];
        
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:distanceString];
        [attributedString1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"American Typewriter" size:15.0] range:NSMakeRange(0, distanceString.length)];
        [attributedString1 addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:(243.0/255) green:(90.0/255) blue:(7.0/255) alpha:1.0]  range:NSMakeRange(0, distanceString.length)];
        [attributedString appendAttributedString:attributedString1];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"天"];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:10.0] range:NSMakeRange(0, 1)];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 1)];
        [attributedString appendAttributedString:attributedString2];
        
        cell.daysLabel.attributedText = attributedString;
    }
    
    //cell.daysLabel.text = distanceString;
    //cell.index = indexPath.row;
    
    return cell;
}





// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView setEditing:YES animated:YES];
//    return UITableViewCellEditingStyleDelete;
//}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [_recordArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate saveRecordData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


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
    //MainTableViewCell *cell = (MainTableViewCell *)sender;
    
    
    if ([[segue identifier] isEqualToString:@"ShowUpdate"]) {
        EditViewController *controller = (EditViewController *)[segue destinationViewController];
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSDictionary *dic = [_recordArray objectAtIndex:path.row];
        controller.editTitle = [dic objectForKey:@"title"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        controller.selectedDate = [formatter dateFromString:[dic objectForKey:@"date"]];
        
        controller.categoryString = [dic objectForKey:@"category"];
        controller.categoryID = [dic objectForKey:@"categoryID"];
        controller.isUpdate = YES;
        controller.updateIndex = path.row;
        controller.mainViewController = self;
        
    }
    else if([[segue identifier] isEqualToString:@"ShowAdd"]) {
        EditViewController *controller = (EditViewController *)[segue destinationViewController];
        //controller.dateArray = _recordArray;
        controller.mainViewController = self;
    }
}

#pragma mark user defiended



@end
