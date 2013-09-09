//
// Created by Chris Eidhof
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import <CoreData/CoreData.h>
#import "Store.h"
#import "Item.h"
#import "NestedTodoListTestCase.h"

@interface StoreTests : NestedTodoListTestCase

@property (nonatomic, strong) Store* store;
@property (nonatomic, strong) id managedObjectContext;

@end

@implementation StoreTests

- (void)setUp
{
    self.store = [[Store alloc] init];
    self.managedObjectContext = [OCMockObject partialMockForObject:self.managedObjectContextForTesting];
    self.store.managedObjectContext = self.managedObjectContext;
}

- (void)testCreateItem
{
    [[self.managedObjectContext expect] insertObject:OCMOCK_ANY];
    Item* object = [Item insertItemWithTitle:@"Hi" parent:nil inManagedObjectContext:self.store.managedObjectContext];
    [self.managedObjectContext verify];
    STAssertEqualObjects(object.parent, nil,nil);
    STAssertEqualObjects(object.title, @"Hi",nil);
}

- (void)testRootItems
{
    Item* one = [Item insertItemWithTitle:@"One" parent:nil inManagedObjectContext:self.store.managedObjectContext];
    Item* two = [Item insertItemWithTitle:@"Two" parent:nil inManagedObjectContext:self.store.managedObjectContext];
    Item* result;
    result= [Item insertItemWithTitle:@"Child" parent:two inManagedObjectContext:self.store.managedObjectContext];
    NSFetchedResultsController* frc = [self.store fetchedResultsControllerForItemsWithParent:nil];
    [frc performFetch:NULL];
    NSArray* items = frc.fetchedObjects;
    STAssertEquals(items.count, (NSUInteger)2, @"Should have two items");
    STAssertEqualObjects(one, items[0], @"One should be the first item");
    STAssertEqualObjects(two, items[1], @"Two should be after one");
}

- (void)testOrder
{
    Item* item1 = [Item insertItemWithTitle:@"One" parent:nil inManagedObjectContext:self.store.managedObjectContext];
    Item* item2 = [Item insertItemWithTitle:@"Two" parent:nil inManagedObjectContext:self.store.managedObjectContext];
    STAssertEquals(item1.order.integerValue, 0, @"Order should start at 0");
    STAssertTrue(item1.order.integerValue < item2.order.integerValue, @"Item 1 should become before item 2");
}

- (void)testUndoManager
{
    NSUndoManager* theUndoManager = [[NSUndoManager alloc] init];
    [[[self.managedObjectContext expect] andReturn:theUndoManager] undoManager];
    STAssertEquals(theUndoManager, self.store.undoManager, @"Should have the same undo manager");
}

- (void)testDelete
{
    NSMutableArray* items = [NSMutableArray array];
    [@[@"one", @"two", @"three", @"four"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
    {
        [items addObject:[Item insertItemWithTitle:obj parent:nil inManagedObjectContext:self.store.managedObjectContext]];

    }];
    id two = items[1];
    [[[self.managedObjectContext expect] andForwardToRealObject] deleteObject:two];
    [self.store deleteItem:two];
    [self verifyOrderInvariant];
}

- (void)verifyOrderInvariant
{
    NSFetchedResultsController* controller = [self.store fetchedResultsControllerForItemsWithParent:nil];
    [controller performFetch:NULL];
    NSLog(@"%@", controller.fetchedObjects);
    [controller.fetchedObjects enumerateObjectsUsingBlock:^(Item* obj, NSUInteger idx, BOOL* stop)
    {
        STAssertEquals(obj.order.integerValue, (NSInteger)idx, @"Order of object should be ascending and starting at 0");
    }];
}

@end