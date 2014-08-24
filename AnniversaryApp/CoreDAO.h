//
//  CoreDAO.h
//  AnniversaryApp
//
//  Created by HeQichang on 14-8-21.
//  Copyright (c) 2014年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDAO : NSObject

+ (NSManagedObjectContext *)sharedContext;

@end
