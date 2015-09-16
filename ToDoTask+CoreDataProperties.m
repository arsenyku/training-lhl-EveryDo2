//
//  ToDoTask+CoreDataProperties.m
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoTask+CoreDataProperties.h"

@implementation ToDoTask (CoreDataProperties)

@dynamic title;
@dynamic taskDescription;
@dynamic priority;
@dynamic completed;
@dynamic completeBy;
@dynamic createdOn;

@end
