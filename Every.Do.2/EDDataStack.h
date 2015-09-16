//
//  EDDataStack.h
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface EDDataStack : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

@end