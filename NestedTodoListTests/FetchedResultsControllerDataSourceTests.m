//
// Created by Chris Eidhof
//


#import <SenTestingKit/SenTestingKit.h>
#import "FetchedResultsControllerDataSource.h"
#import <OCMock/OCMock.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface FetchedResultsControllerDataSourceTests : SenTestCase

@property (nonatomic, strong) FetchedResultsControllerDataSource* fetchedResultsControllerDataSource;

@property (nonatomic, strong) NSIndexPath* defaultIndexPath;
@property (nonatomic, strong) NSNumber* defaultObject;
@end

@interface FetchedResultsControllerDataSourceTests ()

@property (nonatomic, strong) id tableView;
@property (nonatomic, strong) id fetchedResultsController;

@end

@implementation FetchedResultsControllerDataSourceTests

- (void)setUp
{
    self.tableView = [OCMockObject mockForClass:[UITableView class]];
    self.fetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
    self.defaultIndexPath = [NSIndexPath indexPathForRow:111 inSection:222];
    self.defaultObject = @777;
}

- (void)testInitializer
{
    __block id tableViewDataSource = nil;
    [[self.tableView expect] setDataSource:[OCMArg checkWithBlock:^BOOL(id obj) {
        tableViewDataSource = obj;
        return YES;
    }]];
    self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    [self.tableView verify];
    STAssertEqualObjects(tableViewDataSource, self.fetchedResultsControllerDataSource, @"Should assign tableView's datasource");
}

- (void)setUpDataSource
{
    [[self.tableView expect] setDataSource:OCMOCK_ANY];
    [[self.fetchedResultsController expect] setDelegate:OCMOCK_ANY];
    [[self.fetchedResultsController expect] performFetch:NULL];
    self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.fetchedResultsControllerDataSource.fetchedResultsController = self.fetchedResultsController;
}

- (void)testTableViewNumberOfSections
{
    [self setUpDataSource];
    NSArray* sections = @[@0,@0,@0];
    [[[self.fetchedResultsController expect] andReturn:sections] sections];
    STAssertEquals(3, [self.fetchedResultsControllerDataSource numberOfSectionsInTableView:self.tableView],nil);
}

- (void)testTableViewNumberOfRows
{
    [self setUpDataSource];
    id mockedSection = [OCMockObject mockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
    NSUInteger numberOfObjects = 10;
    [[[mockedSection expect] andReturnValue:OCMOCK_VALUE(numberOfObjects)] numberOfObjects];
    NSArray* sections = @[mockedSection];
    [[[self.fetchedResultsController expect] andReturn:sections] sections];
    STAssertEquals(10, [self.fetchedResultsControllerDataSource tableView:self.tableView numberOfRowsInSection:0], @"Should return correct number of rows");
}

- (void)testItemAtIndexPath
{
    [self setUpDataSource];
    id delegate =[OCMockObject mockForProtocol:@protocol(FetchedResultsControllerDataSourceDelegate)];
    self.fetchedResultsControllerDataSource.delegate = delegate;
    id cell = @888;

    [[[self.fetchedResultsController expect] andReturn:self.defaultObject] objectAtIndexPath:self.defaultIndexPath];
    [[[self.tableView expect] andReturn:cell] dequeueReusableCellWithIdentifier:nil forIndexPath:self.defaultIndexPath];
    [[delegate expect] configureCell:cell withObject:self.defaultObject];

    id returnedCell = [self.fetchedResultsControllerDataSource tableView:self.tableView cellForRowAtIndexPath:self.defaultIndexPath];
    [self.fetchedResultsController verify];
    STAssertEqualObjects(returnedCell, cell, @"Should return a cell");
}

- (void)testControllerWillAndDidChangeContent
{
    [self setUpDataSource];
    [[self.tableView expect] beginUpdates];
    [self.fetchedResultsControllerDataSource controllerWillChangeContent:nil];
    [self.tableView verify];

    [[self.tableView expect] endUpdates];
    [self.fetchedResultsControllerDataSource controllerDidChangeContent:nil];
    [self.tableView verify];
}

- (void)testControllerContentChangeInsert
{
    [self setUpDataSource];

    [[self.tableView expect] insertRowsAtIndexPaths:@[self.defaultIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.fetchedResultsControllerDataSource controller:self.fetchedResultsController didChangeObject:self.defaultObject atIndexPath:nil forChangeType:NSFetchedResultsChangeInsert newIndexPath:self.defaultIndexPath];
    [self.tableView verify];
}

- (void)testControllerContentChangeMove
{
    [self setUpDataSource];

    NSIndexPath* secondaryIndexPath = [NSIndexPath indexPathForRow:333 inSection:444];
    [[self.tableView expect] moveRowAtIndexPath:self.defaultIndexPath toIndexPath:secondaryIndexPath];
    [self.fetchedResultsControllerDataSource controller:self.fetchedResultsController didChangeObject:self.defaultObject atIndexPath:self.defaultIndexPath forChangeType:NSFetchedResultsChangeMove newIndexPath:secondaryIndexPath];
    [self.tableView verify];
}

- (void)testControllerContentChangeDelete
{
    [self setUpDataSource];

    [[self.tableView expect] deleteRowsAtIndexPaths:@[self.defaultIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.fetchedResultsControllerDataSource controller:self.fetchedResultsController didChangeObject:self.defaultObject atIndexPath:self.defaultIndexPath forChangeType:NSFetchedResultsChangeDelete newIndexPath:nil];
    [self.tableView verify];
}

- (void)testSetFetchedResultsController
{
    [self.fetchedResultsController verify];
}

- (void)testSelectedItem
{
    [self setUpDataSource];
    [[[self.tableView expect] andReturn:self.defaultIndexPath] indexPathForSelectedRow];
    [[[self.fetchedResultsController expect] andReturn:@123] objectAtIndexPath:self.defaultIndexPath];
    id result = [self.fetchedResultsControllerDataSource selectedItem];
    STAssertEqualObjects(@123, result, @"Should return the selected item");

    [[[self.tableView expect] andReturn:nil] indexPathForSelectedRow];
    id nilResult = [self.fetchedResultsControllerDataSource selectedItem];
    STAssertNil(nilResult, @"Should have a nil result");

    [self.tableView verify];
    [self.fetchedResultsController verify];
}

- (void)testPausing
{
    [self setUpDataSource];
    [[self.fetchedResultsController expect] setDelegate:nil];
    self.fetchedResultsControllerDataSource.paused = YES;
    [self.fetchedResultsController verify];

    [[self.fetchedResultsController expect] setDelegate:self.fetchedResultsControllerDataSource];
    [[self.fetchedResultsController expect] performFetch:NULL];
    [[self.tableView expect] reloadData];
    self.fetchedResultsControllerDataSource.paused = NO;
    [self.fetchedResultsController verify];

}

- (void)testEditing
{
    [self setUpDataSource];
    BOOL result = [self.fetchedResultsControllerDataSource tableView:self.tableView canEditRowAtIndexPath:self.defaultIndexPath];
    STAssertTrue(result, @"Should be able to edit rows");

    id obj = @678;
    [[[self.fetchedResultsController expect] andReturn:obj] objectAtIndexPath:self.defaultIndexPath];
    id delegate = [OCMockObject mockForProtocol:@protocol(FetchedResultsControllerDataSourceDelegate)];
    self.fetchedResultsControllerDataSource.delegate = delegate;
    [[delegate expect] deleteObject:obj];
    [self.fetchedResultsControllerDataSource tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:self.defaultIndexPath];
    [delegate verify];
}

@end