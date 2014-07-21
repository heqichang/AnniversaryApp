//
//  MainTableViewController.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-3.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"
@class FPPopoverController;

@interface MainTableViewController : UITableViewController<UIGestureRecognizerDelegate, FPPopoverControllerDelegate>
{
    NSMutableArray * _recordArray;
    FPPopoverController * _popover;
}

-(void)selectedTableRow:(NSUInteger)rowNum;
@end
