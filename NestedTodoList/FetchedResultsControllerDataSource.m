//
// Created by Chris Eidhof
//


#import <CoreData/CoreData.h>
#import "FetchedResultsControllerDataSource.h"


@interface FetchedResultsControllerDataSource ()

@property (nonatomic, readwrite) UITableView* tableView;

@end

@implementation FetchedResultsControllerDataSource

- (instancetype)initWithTableView:(UITableView*)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _tableView.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView*)tableView {
    return (NSInteger)self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(__unused UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[(NSUInteger)sectionIndex];
    return (NSInteger)section.numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id<FetchedResultsControllerDataSourceDelegate> strongDelegate = self.delegate;
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier
                                              forIndexPath:indexPath];
    [strongDelegate configureCell:cell withObject:object];
    return cell;
}

- (BOOL)tableView:(__unused UITableView*)tableView canEditRowAtIndexPath:(__unused NSIndexPath*)indexPath {
    return YES;
}

- (void)tableView:(__unused UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   id<FetchedResultsControllerDataSourceDelegate> strongDelegate = self.delegate;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [strongDelegate deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(__unused NSFetchedResultsController*)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(__unused NSFetchedResultsController*)controller {
    [self.tableView endUpdates];
}

- (void)controller:(__unused NSFetchedResultsController*)controller didChangeObject:(__unused id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath
                                   toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            NSAssert(NO,@"");
            break;
    }
}

- (void)setFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController {
    NSAssert(_fetchedResultsController == nil, @"TODO: you can currently only assign this property once");
    _fetchedResultsController = fetchedResultsController;
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:NULL];
}


- (id)selectedItem {
    NSIndexPath* path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}


- (void)setPaused:(BOOL)paused {
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    }
    else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
        [self.tableView reloadData];
    }
}


@end
