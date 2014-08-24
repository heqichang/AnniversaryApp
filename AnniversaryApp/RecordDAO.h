//
//  RecordDao.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-8-22.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import "CoreDAO.h"
@class Record;
@class RecordCategory;

@interface RecordDAO : CoreDAO

- (Record *)addRecordTitle:(NSString *)title date:(NSDate *)date category:(RecordCategory *)category;
- (void)updateRecord:(Record *)record;
- (BOOL)deleteRecord:(Record *)record;
- (NSMutableArray *)findAll;

@end
