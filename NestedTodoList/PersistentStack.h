//
// Created by Chris Eidhof
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersistentStack : NSObject

- (instancetype)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL;

@property (nonatomic, readonly) NSManagedObjectContext* managedObjectContext;

@end
