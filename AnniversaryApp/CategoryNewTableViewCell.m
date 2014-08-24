//
//  CategoryNewTableViewCell.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-17.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "CategoryNewTableViewCell.h"
#import "AppDelegate.h"

#import "RecordCategoryDAO.h"

@implementation CategoryNewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UITextFieldDelegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (isEmpty(self.categoryTextField.text)) {
        [self.categoryTextField resignFirstResponder];
        return NO;
    } else {
        RecordCategoryDAO *categoryDAO = [[RecordCategoryDAO alloc] init];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.categoryArray addObject:[categoryDAO addRecordCategoryName:self.categoryTextField.text]];
        
        [self.parentTableView reloadData];
        [self.categoryTextField resignFirstResponder];
        return YES;
    }
    
}

#pragma mark user defineded

static inline BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

@end
