//
//  MainTableViewCell.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-5.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

@property (strong, nonatomic) NSString *categoryString;
@end
