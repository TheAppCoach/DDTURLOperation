#import "DeleteOperation.h"
#import "AFNetworking.h"
#import <CoreData/CoreData.h>
#import "BaseObject.h"

@implementation DeleteOperation
{
    BOOL        _executing;
    BOOL        _finished;
    
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectContext *_context;
    NSManagedObjectContext *_mainThreadContext;
    
    NSURL *_url;
}

- (BOOL)isConcurrent
{
    return NO;
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)completeOperation
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (instancetype) initWithURL:(NSURL *)url persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mainThreadContext:(NSManagedObjectContext *)mainThreadContext
{
    if (self = [super init]) {
        _url = url;
        
        _executing = NO;
        _finished = NO;
        
        _persistentStoreCoordinator = persistentStoreCoordinator;
        _mainThreadContext = mainThreadContext;
    }
    return self;
}


- (void)start
{
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)mergeChanges:(NSNotification *)notification
{
    // Merge changes into the main context on the main thread
    [_mainThreadContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                         withObject:notification
                                      waitUntilDone:YES];
    
    [self completeOperation];
}

- (void)main {
    @try {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setUndoManager:nil];
        [_context setPersistentStoreCoordinator: _persistentStoreCoordinator];
        
        
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(mergeChanges:)
                       name:NSManagedObjectContextDidSaveNotification
                     object:_context];
            
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:_url];
        [request setHTTPMethod:@"DELETE"];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *dict) {
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    BaseObject *baseObject = [BaseObject deletedBaseObjectWithUnquieId:dict[@"uniqueId"] withManagedObjectContext:_context];
                    
                    if(baseObject) {
                        [_context deleteObject:baseObject];
                        
                        NSError *error = nil;
                        [_context save:&error];
                        
                        assert(!error);
                    }
                    
                    
                    
             [self completeOperation];
                });
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error DELETE"]
                                                message:[_url absoluteString]
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil] show];
                    
                    
                    [self completeOperation];
                });
            }];
            
            [operation start];
            
        }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
