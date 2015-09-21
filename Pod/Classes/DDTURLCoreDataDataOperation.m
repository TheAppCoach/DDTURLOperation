#import "DDTURLCoreDataDataOperation.h"
#import <CoreData/CoreData.h>

@implementation DDTURLCoreDataDataOperation
{
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectContext *_context;
    NSManagedObjectContext *_mainThreadContext;
    
    NSURL *_url;
    
    NSURLRequest *_request;
    
    BOOL _finished;
    BOOL _executing;
    
    NSURLSession *_session;
    NSURLSessionTask *_task;
    
    void (^_completionHandler)(NSManagedObjectContext *context, NSData *data, NSURLResponse *response, NSError *error) ;
    
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
    //    NSLog(@"PushOperation -> completeOperation");
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

+ (instancetype)operationWithRequest:(NSURLRequest *)request persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mainThreadContext:(NSManagedObjectContext *)mainThreadContext completionHandler:(void (^)(NSManagedObjectContext *context,NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return [[[self class] alloc] initWithSession:session Request:request persistentStoreCoordinator:persistentStoreCoordinator mainThreadContext:mainThreadContext completionHandler:completionHandler];
}

- (instancetype)initWithSession:(NSURLSession *)session Request:(NSURLRequest *)request persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mainThreadContext:(NSManagedObjectContext *)mainThreadContext completionHandler:(void (^)(NSManagedObjectContext *context, NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    if (self = [super init]) {
        _session = session;
        _request = request;
        _persistentStoreCoordinator = persistentStoreCoordinator;
        _mainThreadContext = mainThreadContext;
        _completionHandler = completionHandler;
    }
    return self;
}


+ (instancetype)operationWithURL:(NSURL *)url persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mainThreadContext:(NSManagedObjectContext *)mainThreadContext completionHandler:(void (^)(NSManagedObjectContext *context,NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return [[[self class] alloc] initWithSession:session URL:url persistentStoreCoordinator:persistentStoreCoordinator mainThreadContext:mainThreadContext completionHandler:completionHandler];
}

- (instancetype)initWithSession:(NSURLSession *)session URL:(NSURL *)url persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator mainThreadContext:(NSManagedObjectContext *)mainThreadContext completionHandler:(void (^)(NSManagedObjectContext *context, NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    if (self = [super init]) {
        _session = session;
        _url = url;
        _persistentStoreCoordinator = persistentStoreCoordinator;
        _mainThreadContext = mainThreadContext;
        _completionHandler = completionHandler;
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
    
}

- (void)main {
    @try {
        
        // create our own context here to work with
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_context setUndoManager:nil];
        [_context setPersistentStoreCoordinator: _persistentStoreCoordinator];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(mergeChanges:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:_context];
        
         __weak typeof(self) weakSelf = self;
      
        if (_url) {
        _task = [_session dataTaskWithURL:_url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            _completionHandler(_context, data, response, error);
            
            [weakSelf completeOperation];
        }];
        }
        else if (_request) {
            _task = [_session dataTaskWithRequest:_request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                _completionHandler(_context, data, response, error);
                
                [weakSelf completeOperation];
            }];
        }
        
        [_task resume];
    }
    @catch(...) {
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
