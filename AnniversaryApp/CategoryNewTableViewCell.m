//
//  CategoryNewTableViewCell.m
//  AnniversaryApp
//
//  Created by HeQichang on 14-7-17.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "CategoryNewTableViewCell.h"
#import "AppDelegate.h"

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
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        NSMutableArray *recordCategory = delegate.categoryArray;
        
        NSMutableDictionary *categoryDict = delegate.categoryDict;
        
        // 获取最大id
        NSInteger maxId = 0;
        for (NSString *key in categoryDict) {
            NSInteger temp = [key intValue];
            if (temp > maxId) {
                maxId = temp;
            }
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.categoryTextField.text forKey:@"name"];
        [dic setObject:[NSString stringWithFormat:@"%d", maxId + 1] forKey:@"id"];
        [recordCategory addObject:dic];
        [categoryDict setObject:self.categoryTextField.text forKey:[NSString stringWithFormat:@"%d", maxId + 1]];
        
        [delegate saveCategory];
        
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
