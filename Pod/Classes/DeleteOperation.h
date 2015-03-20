#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface DeleteOperation : NSOperation <NSXMLParserDelegate>

- (instancetype) initWithURL:(NSURL *)url persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mainThreadContext:(NSManagedObjectContext *)mainThreadContext;

@end
