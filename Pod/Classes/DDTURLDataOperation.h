#import <Foundation/Foundation.h>
#import "DDTOperation.h"

@interface DDTURLDataOperation : DDTOperation

+ (instancetype)operationWithURL:(NSURL *)url completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
