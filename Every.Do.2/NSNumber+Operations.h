//
//  NSNumber+Operations.h
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Operations)

-(NSNumber*)plus:(NSNumber*)otherNumber;
-(NSNumber*)minus:(NSNumber*)otherNumber;
-(NSNumber*)multipliedBy:(NSNumber*)otherNumber;
-(NSNumber*)dividedBy:(NSNumber*)otherNumber;

@end
