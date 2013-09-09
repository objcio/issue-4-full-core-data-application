//
// Created by Chris Eidhof
//


#import <Foundation/Foundation.h>

@class FetchedResultsControllerDataSource;
@class Store;
@class Item;


@interface ItemViewController : UITableViewController

@property (nonatomic, strong) Item* parent;

@end