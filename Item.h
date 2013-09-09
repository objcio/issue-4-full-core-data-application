//
//  Item.h
//  NestedTodoList
//
//  Created by Chris Eidhof on 8/14/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, assign) NSNumber* order;
@property (nonatomic, retain) Item* parent;
@property (nonatomic, retain) NSSet* children;

+ (instancetype)insertItemWithTitle:(NSString*)title
                             parent:(Item*)parent
             inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (NSFetchedResultsController*)childrenFetchedResultsController;

@end