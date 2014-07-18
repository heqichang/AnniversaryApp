//
//  CategoryNewTableViewCell.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-17.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryNewTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;

@property (strong, nonatomic) UITableView *parentTableView;
// @property (strong, nonatomic) NSString *categoryString;

@end
