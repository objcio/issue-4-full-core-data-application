//
// Created by Chris Eidhof
//

@class Item;
@class NSFetchedResultsController;

@interface Store : NSObject

@property (nonatomic) NSManagedObjectContext* managedObjectContext;

- (Item*)rootItem;

@end
