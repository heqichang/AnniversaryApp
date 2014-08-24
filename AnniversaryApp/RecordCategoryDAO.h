//
//  RecordCategoryDAO.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-8-23.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "CoreDAO.h"
@class RecordCategory;

@interface RecordCategoryDAO : CoreDAO

- (RecordCategory *)addRecordCategoryName:(NSString *)name;
- (void)updateRecord:(RecordCategory *)category;
- (BOOL)deleteRecord:(RecordCategory *)category;
- (NSMutableArray *)findAll;
@end
