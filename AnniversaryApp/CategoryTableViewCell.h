//
//  CategoryTableViewCell.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-16.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (strong, nonatomic) NSString *categoryID;
@end
