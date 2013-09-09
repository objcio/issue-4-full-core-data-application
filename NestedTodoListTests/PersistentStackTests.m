//
//  PersistentStackTests.m
//  NestedTodoList
//
//  Created by Chris Eidhof on 8/13/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "PersistentStack.h"

@interface PersistentStackTests : SenTestCase

@property (nonatomic, strong) PersistentStack* persistentStack;

@end

@implementation PersistentStackTests

- (void)setUp
{
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"NestedTodoList" withExtension:@"momd"];
    NSURL* storeURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.sqlite"]];
    self.persistentStack = [[PersistentStack alloc] initWithStoreURL:storeURL modelURL:modelURL];
}

- (void)testInitializer
{
    STAssertNotNil(self.persistentStack, @"Should have a persistent stack");
}

- (void)testManagedObjectContext
{
    STAssertNotNil(self.persistentStack.managedObjectContext, @"Should have a managed object context");
    STAssertNotNil(self.persistentStack.managedObjectContext.persistentStoreCoordinator, @"Should have a persistent store coordinator");
    NSPersistentStore* store = self.persistentStack.managedObjectContext.persistentStoreCoordinator.persistentStores[0];
    STAssertNotNil(store, @"Should have a persistent store");
    STAssertEqualObjects(store.type, NSSQLiteStoreType, @"Should be a sqlite store");
    STAssertNotNil(self.persistentStack.managedObjectContext.undoManager, @"Should have an undo manager");
}

@end
