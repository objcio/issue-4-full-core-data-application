//
//  PersistentStackTests.m
//  NestedTodoList
//
//  Created by Chris Eidhof on 8/13/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PersistentStack.h"

@interface PersistentStackTests : XCTestCase

@property (nonatomic, strong) PersistentStack* persistentStack;

@end

@implementation PersistentStackTests

- (void)setUp
{
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"NestedTodoList" withExtension:@"momd"];
    NSURL* storeURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"test.sqlite"]];
    self.persistentStack = [[PersistentStack alloc] initWithStoreURL:storeURL modelURL:modelURL];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
- (void)testInitializer
{
    XCTAssertNotNil(self.persistentStack, @"Should have a persistent stack");
}

- (void)testManagedObjectContext
{
    XCTAssertNotNil(self.persistentStack.managedObjectContext, @"Should have a managed object context");
    XCTAssertNotNil(self.persistentStack.managedObjectContext.persistentStoreCoordinator, @"Should have a persistent store coordinator");
    NSPersistentStore* store = self.persistentStack.managedObjectContext.persistentStoreCoordinator.persistentStores[0];
    XCTAssertNotNil(store, @"Should have a persistent store");
    XCTAssertEqualObjects(store.type, NSSQLiteStoreType, @"Should be a sqlite store");
    XCTAssertNotNil(self.persistentStack.managedObjectContext.undoManager, @"Should have an undo manager");
}
#pragma clang diagnostic pop

@end
