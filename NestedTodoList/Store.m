//
// Created by Chris Eidhof
//


#import <CoreData/CoreData.h>
#import "Store.h"
#import "Item.h"


@implementation Store

- (Item*)rootItem
{
    // todo: use a cache?
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", nil];
    NSError *error;
    NSArray* objects = [self.managedObjectContext executeFetchRequest:request
                                                                error:&error];
    
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    Item* rootItem = [objects lastObject];
    if (rootItem == nil) {
        rootItem = [Item insertItemWithTitle:nil
                                      parent:nil
                      inManagedObjectContext:self.managedObjectContext];
    }
    return rootItem;
}

@end
