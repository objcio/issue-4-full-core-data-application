//
// Created by Chris Eidhof
//


#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

@interface NestedTodoListTestCase : SenTestCase

- (NSManagedObjectContext*)managedObjectContextForTesting;

@end