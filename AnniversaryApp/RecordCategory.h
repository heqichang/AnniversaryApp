//
//  Category.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-8-22.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecordCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *record;

@end
