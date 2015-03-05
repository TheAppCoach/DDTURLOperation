//
//  DDTOperation.h
//  DDTURLOperationBuild
//
//  Created by Daren David Taylor on 03/03/2015.
//  Copyright (c) 2015 DDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDTOperation : NSOperation

- (void)completeOperation;

@property (nonatomic, readwrite, retain) NSURLSessionTask *task;

@end
