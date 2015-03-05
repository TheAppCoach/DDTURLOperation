#import "DDTURLDownloadOperation.h"

@implementation DDTURLDownloadOperation

@synthesize task = _task;

#pragma mark - public

+ (instancetype)operationWithURL:(NSURL *)url completionHandler:(void (^)(NSURL *url, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return [[[self class] alloc] initWithSession:session URL:url completionHandler:completionHandler];
}

#pragma mark - private

- (instancetype)initWithSession:(NSURLSession *)session URL:(NSURL *)url completionHandler:(void (^)(NSURL *url, NSURLResponse *response, NSError *error))completionHandler
{
    if (self = [super init]) {
        __weak typeof(self) weakSelf = self;
        
        _task = [session downloadTaskWithURL:url completionHandler:^(NSURL *url, NSURLResponse *response, NSError *error) {
            if (!weakSelf.isCancelled && completionHandler) {
                completionHandler(url, response, error);
            }
            [self completeOperation];
        }];
    }
    return self;
}

@end

