//
// Created by Chris Eidhof
//

@import CoreData;

@interface PersistentStack : NSObject

- (instancetype)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL;

@property (nonatomic, readonly) NSManagedObjectContext* managedObjectContext;

@end
