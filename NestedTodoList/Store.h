//
// Created by Chris Eidhof
//


#import <Foundation/Foundation.h>

@class Item;
@class NSFetchedResultsController;

@interface Store : NSObject

@property (nonatomic) NSManagedObjectContext* managedObjectContext;

- (Item*)rootItem;

@end
