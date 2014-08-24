//
//  Record.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-8-22.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecordCategory;

@interface Record : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) RecordCategory *category;

@end
