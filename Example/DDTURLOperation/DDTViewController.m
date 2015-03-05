//
//  DDTViewController.m
//  DDTURLOperation
//
//  Created by mcBontempi on 03/05/2015.
//  Copyright (c) 2014 mcBontempi. All rights reserved.
//

#import "DDTViewController.h"
#import <DDTURLDownloadOperation.h>

@interface DDTViewController ()
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation DDTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://i00.i.aliimg.com/wsphoto/v1/1299469656_1/DI2-Groupset-Fit-Carbon-TT-Frame-Matte-Black-Carbon-Road-Time-Trial-Frameset-For-Sale.jpg"];
    
    [self.queue addOperation:[DDTURLDownloadOperation operationWithURL:url completionHandler:^(NSURL *url, NSURLResponse *response, NSError *error) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        assert(image);
    }]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
