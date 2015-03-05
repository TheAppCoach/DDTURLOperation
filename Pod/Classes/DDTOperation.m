//
//  DDTOperation.m
//  DDTURLOperationBuild
//
//  Created by Daren David Taylor on 03/03/2015.
//  Copyright (c) 2015 DDT. All rights reserved.
//

#import "DDTOperation.h"

#define DDTBlock(KP, B) \
[self willChangeValueForKey:KP]; \
B(); \
[self didChangeValueForKey:KP];

@interface DDTOperation ()

@end

@implementation DDTOperation
{
    BOOL _finished;
    BOOL _executing;
}

- (void)cancel
{
    [super cancel];
    [self.task cancel];
}

- (void)start
{
    if (self.isCancelled) {
        DDTBlock(@"isFinished", ^{ _finished = YES; });
        return;
    }
    DDTBlock(@"isExecuting", ^{
        [self.task resume];
        _executing = YES;
    });
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

- (BOOL)isConcurrent
{
    return YES;
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

@end

