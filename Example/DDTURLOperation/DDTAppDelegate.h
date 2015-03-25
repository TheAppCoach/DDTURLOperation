//
//  DDTAppDelegate.h
//  DDTURLOperation
//
//  Created by CocoaPods on 03/05/2015.
//  Copyright (c) 2014 mcBontempi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@end
