//
//  NSNumber+Operations.m
//  Every.Do.2
//
//  Created by asu on 2015-09-16.
//  Copyright © 2015 asu. All rights reserved.
//

#import "NSNumber+Operations.h"

@implementation NSNumber (Operations)

-(NSNumber*)plus:(NSNumber*)otherNumber{
    return [NSNumber numberWithFloat:([self floatValue] + [otherNumber floatValue])];
}
-(NSNumber*)minus:(NSNumber*)otherNumber{
    return [NSNumber numberWithFloat:([self floatValue] - [otherNumber floatValue])];
}
-(NSNumber*)multipliedBy:(NSNumber*)otherNumber{
    return [NSNumber numberWithFloat:([self floatValue] * [otherNumber floatValue])];
}
-(NSNumber*)dividedBy:(NSNumber*)otherNumber{
    return [NSNumber numberWithFloat:([self floatValue] / [otherNumber floatValue])];
}

@end
