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

@property (nonatomic, readwrite) Store* store;
@property (nonatomic, readwrite) PersistentStack* persistentStack;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions
{
    UINavigationController* navigationController = (UINavigationController *) self.window.rootViewController;
    ItemViewController* rootViewController = (ItemViewController *)navigationController.topViewController;
    
    NSAssert([rootViewController isKindOfClass:[ItemViewController class]], @"The root view controller is not a an instance of ItemViewController.");
    
    self.persistentStack = [[PersistentStack alloc] initWithStoreURL:self.storeURL
                                                            modelURL:self.modelURL];
    self.store = [[Store alloc] init];
    self.store.managedObjectContext = self.persistentStack.managedObjectContext;
    rootViewController.parent = self.store.rootItem;
    application.applicationSupportsShakeToEdit = YES;
    
    return YES;
}

- (NSURL *)storeURL {
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL];
    
#if DEBUG
    NSLog(@"\n  %@\n", [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"]);
#endif
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL *)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"NestedTodoList"
                                   withExtension:@"momd"];
}

- (void)applicationDidEnterBackground:(__unused UIApplication *)application {
    NSError *error;
    [self.store.managedObjectContext save:&error];
}


@end
