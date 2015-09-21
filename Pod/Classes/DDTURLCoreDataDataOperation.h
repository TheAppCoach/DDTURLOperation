#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "DDTOperation.h"

@interface DDTURLCoreDataDataOperation : NSOperation

+ (instancetype)operationWithURL:(NSURL *)url persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mainThreadContext:(NSManagedObjectContext *)mainThreadContext completionHandler:(void (^)(NSManagedObjectContext *context,NSData *data, NSURLResponse *response, NSError *error))completionHandler;

+ (instancetype)operationWithRequest:(NSURLRequest *)request persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mainThreadContext:(NSManagedObjectContext *)mainThreadContext completionHandler:(void (^)(NSManagedObjectContext *context,NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end 
