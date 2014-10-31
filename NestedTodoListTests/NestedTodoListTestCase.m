//
// Created by Chris Eidhof
//

#import "NestedTodoListTestCase.h"
@import CoreData;

@implementation NestedTodoListTestCase

- (NSManagedObjectContext*)managedObjectContextForTesting
{
    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"NestedTodoList" withExtension:@"momd"]];
    moc.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    return moc;
}

@end
