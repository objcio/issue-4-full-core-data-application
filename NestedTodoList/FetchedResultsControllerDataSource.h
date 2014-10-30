//
// Created by Chris Eidhof
//

@import CoreData;

@class NSFetchedResultsController;

@protocol FetchedResultsControllerDataSourceDelegate

- (void)configureCell:(id)cell withObject:(id)object;
- (void)deleteObject:(id)object;

@end



@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, weak) id<FetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString* reuseIdentifier;
@property (nonatomic) BOOL paused;

- (instancetype)initWithTableView:(UITableView*)tableView;
- (id)selectedItem;

@end
