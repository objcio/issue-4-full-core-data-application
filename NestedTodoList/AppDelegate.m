//
//  AppDelegate.m
//  NestedTodoList
//
//  Created by Chris Eidhof on 8/13/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemViewController.h"
#import "Store.h"
#import "PersistentStack.h"

@interface AppDelegate ()

@property (nonatomic, strong) Store* store;
@property (nonatomic, strong) PersistentStack* persistentStack;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    UINavigationController* navigationController = (UINavigationController*) self.window.rootViewController;
    ItemViewController* rootViewController = (ItemViewController*)navigationController.topViewController;
    NSAssert([rootViewController isKindOfClass:[ItemViewController class]], @"Should have an item view controller");
    self.persistentStack = [[PersistentStack alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    self.store = [[Store alloc] init];
    self.store.managedObjectContext = self.persistentStack.managedObjectContext;
    rootViewController.parent = self.store.rootItem;
    application.applicationSupportsShakeToEdit = YES;
    return YES;
}

- (NSURL*)storeURL
{
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"NestedTodoList" withExtension:@"momd"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.store.managedObjectContext save:NULL];
}


@end
