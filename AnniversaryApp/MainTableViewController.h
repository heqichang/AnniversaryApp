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
@class RecordCategory;

@interface MainTableViewController : UITableViewController<UIGestureRecognizerDelegate, FPPopoverControllerDelegate>


-(void)selectedCategory:(RecordCategory *)category;
@end
