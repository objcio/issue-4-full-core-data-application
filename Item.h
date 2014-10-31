//
//  Item.h
//  NestedTodoList
//
//  Created by Chris Eidhof on 8/14/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

@import CoreData;

@class Item;

@interface Item : NSManagedObject

@property (nonatomic) NSString* title;
@property (nonatomic) NSNumber* order;
@property (nonatomic) Item* parent;
@property (nonatomic) NSSet* children;

+ (instancetype)insertItemWithTitle:(NSString*)title
                             parent:(Item*)parent
             inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

- (NSFetchedResultsController*)childrenFetchedResultsController;

@end
