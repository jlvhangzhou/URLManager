//
//  UMgrDemoBViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/7/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMgrDemoBViewController.h"

@interface UMgrDemoBViewController ()

@end

@implementation UMgrDemoBViewController

- (id)initWithURL:(NSURL *)aUrl
{
    self = [super initWithURL:aUrl];
    if (self) {
        NSLog(@"URL:%@", self.umUrl.absoluteString);
        NSLog(@"PARAMS:%@", self.params);
    }
    return self;
}

- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query
{
    self = [super initWithURL:aUrl query:query];
    if (self) {
        NSLog(@"URL:%@", self.umUrl.absoluteString);
        NSLog(@"PARAMS:%@", self.params);
        NSLog(@"QUERY:%@", self.query);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
    NSLog(@"Opened From:%@", aUrl.absoluteString);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
