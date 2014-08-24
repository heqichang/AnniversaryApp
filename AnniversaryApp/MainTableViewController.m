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

#import "CategoryMenuTableViewController.h"
#import "FPPopoverController.h"

#import "Record.h"
#import "RecordCategory.h"

#import "RecordDAO.h"

@interface MainTableViewController ()
{
    NSMutableArray * _showedArray;
    UIButton * _menuButton;
    FPPopoverController * _popover;
    AppDelegate * _delegate;
}

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
    _delegate = delegate;
    _showedArray = delegate.recordArray;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.bounds.size.height)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _menuButton = button1;
    button1.frame = view.frame;
    [button1 setTitle:@"全部" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    
    self.navigationItem.titleView = view;
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
    return [_showedArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"cell";
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // 有个方法 timeIntervalSinceNow 但不正确，如果正好设置前一天或者后一天显示有误
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    Record *record = _showedArray[indexPath.row];
    cell.titleLabel.text = record.title;
    cell.dateLabel.text = [formatter stringFromDate:record.date];
    
    
    NSDate *now = [NSDate date];
    now = [formatter dateFromString:[formatter stringFromDate:now]];
    NSDate *past = record.date;
    past = [formatter dateFromString:[formatter stringFromDate:past]];
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
        NSLog(@"%d", indexPath.row);
        RecordDAO *recordDAO = [[RecordDAO alloc] init];
        BOOL deleted = [recordDAO deleteRecord:_showedArray[indexPath.row]];
        
        if (deleted) {
            [_delegate.recordArray removeObject:_showedArray[indexPath.row]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
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
    
    
    if ([[segue identifier] isEqualToString:@"ShowUpdate"]) {
        
        EditViewController *controller = (EditViewController *)[segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Record *record = _delegate.recordArray[path.row];
        
        controller.isUpdate = YES;
        controller.record = record;
        controller.mainViewController = self;
        
    }
    else if([[segue identifier] isEqualToString:@"ShowAdd"]) {
        EditViewController *controller = (EditViewController *)[segue destinationViewController];
        controller.mainViewController = self;
    }
}

#pragma mark user defiended

- (void)clickTitle:(id)sender
{
    CategoryMenuTableViewController *menu = [[CategoryMenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
    menu.delegate = self;
    _popover = [[FPPopoverController alloc] initWithViewController:menu];
    _popover.delegate = self;
    _popover.title = nil;
    _popover.tint = FPPopoverWhiteTint;
    _popover.arrowDirection = FPPopoverArrowDirectionAny;
    _popover.border = NO;
    [_popover presentPopoverFromView:sender];
    
}

-(void)selectedCategory:(RecordCategory *)category
{
    NSString *title = @"全部";
    if (category) {
        title = category.name;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", category];
        _showedArray = [[_delegate.recordArray  filteredArrayUsingPredicate:predicate] mutableCopy];
    } else {
        _showedArray = _delegate.recordArray;
    }
    
    [_menuButton setTitle:title forState:UIControlStateNormal];
    [self.tableView reloadData];
    [_popover dismissPopoverAnimated:YES];
}

#pragma mark FPPopoverControllerDelegate method

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    //[visiblePopoverController dismissPopoverAnimated:YES];
}



@end
