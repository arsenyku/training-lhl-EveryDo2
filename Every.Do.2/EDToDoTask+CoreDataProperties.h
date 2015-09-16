//
//  EDToDoTask+CoreDataProperties.h
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EDToDoTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface EDToDoTask (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *taskDescription;
@property (nullable, nonatomic, retain) NSNumber *priority;
@property (nonatomic, assign) BOOL completed;
@property (nullable, nonatomic, retain) NSDate *completeBy;
@property (nullable, nonatomic, retain) NSDate *createdOn;

@end

NS_ASSUME_NONNULL_END
