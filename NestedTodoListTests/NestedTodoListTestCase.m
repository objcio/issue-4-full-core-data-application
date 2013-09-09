//
// Created by Chris Eidhof
//


#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>
#import "NestedTodoListTestCase.h"


@implementation NestedTodoListTestCase

- (NSManagedObjectContext*)managedObjectContextForTesting
{
    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"NestedTodoList" withExtension:@"momd"]];
    moc.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    return moc;
}

@end