#import <Foundation/Foundation.h>
#import "DDTOperation.h"

@interface DDTURLDownloadOperation : DDTOperation

+ (instancetype)operationWithURL:(NSURL *)url completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;

@end
