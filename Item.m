//
//  Item.m
//  NestedTodoList
//
//  Created by Chris Eidhof on 8/14/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import "Item.h"
#import "Item.h"


@implementation Item

@dynamic title;
@dynamic parent;
@dynamic children;
@dynamic order;

+ (instancetype)insertItemWithTitle:(NSString*)title
                             parent:(Item*)parent
             inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSUInteger order = parent.numberOfChildren;
    Item* item = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                               inManagedObjectContext:managedObjectContext];
    item.title = title;
    item.parent = parent;
    item.order = @(order);
    return item;
}

+ (NSString*)entityName
{
    return @"Item";
}

- (NSUInteger)numberOfChildren
{
    return self.children.count;
}

- (NSFetchedResultsController*)childrenFetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)prepareForDeletion
{
    if (self.parent.isDeleted) return;
    
    NSSet* siblings = self.parent.children;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"order > %@", self.order];
    NSSet* itemsAfterSelf = [siblings filteredSetUsingPredicate:predicate];
    [itemsAfterSelf enumerateObjectsUsingBlock:^(Item* sibling, BOOL* stop)
    {
        sibling.order = @(sibling.order.integerValue - 1);
    }];
}

@end
