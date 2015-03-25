//
//  DDTViewController.m
//  DDTURLOperation
//
//  Created by mcBontempi on 03/05/2015.
//  Copyright (c) 2014 mcBontempi. All rights reserved.
//

#import "DDTViewController.h"
#import <DDTURLDownloadOperation.h>
#import <DDTURLDataOperation.h>
#import <DDTURLCoreDataDataOperation.h>
#import "DDTAppDelegate.h"
#import "TestEntity.h"

@interface DDTViewController ()
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation DDTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
    
    [self download];
    
    [self data];
    
    [self coreData];
}

- (void)download
{
    NSURL *url = [NSURL URLWithString:@"http://www.theappcoach.com/wp-content/uploads/2015/02/Screen-Shot-2015-02-20-at-12.32.54.png"];
    
    [self.queue addOperation:[DDTURLDownloadOperation operationWithURL:url completionHandler:^(NSURL *url, NSURLResponse *response, NSError *error) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        assert(image);
    }]];
}

- (void)data
{
    NSURL *url = [NSURL URLWithString:@"http://theappcoach.com/readme.html"];
    
    [self.queue addOperation:[DDTURLDataOperation operationWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        assert(data);
    }]];
}

- (void)coreData
{
    DDTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:@"http://theappcoach.com/readme.html"];
    
    [self.queue addOperation:[DDTURLCoreDataDataOperation operationWithURL:url persistentStoreCoordinator:appDelegate.persistentStoreCoordinator mainThreadContext:appDelegate.managedObjectContext completionHandler:^(NSManagedObjectContext *context, NSData *data, NSURLResponse *response, NSError *error) {
        
        // update your data model syncronously using the suppied context
        
        TestEntity *testEntity = [[TestEntity alloc] initWithEntity:[NSEntityDescription
                                                                     entityForName:@"TestEntity" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        
        testEntity.testAttribute = @"Hello World";
       
        // save to the provided context, this context will be merged to the mainThreadContext
        NSError *saveError = nil;
        [context save:&saveError];
    }]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
