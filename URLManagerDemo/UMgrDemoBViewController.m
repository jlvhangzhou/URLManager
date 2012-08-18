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
        NSLog(@"URL:%@", self.url.absoluteString);
        NSLog(@"PARAMS:%@", self.params);
    }
    return self;
}

- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query
{
    self = [super initWithURL:aUrl query:query];
    if (self) {
        NSLog(@"URL:%@", self.url.absoluteString);
        NSLog(@"PARAMS:%@", self.params);
        NSLog(@"QUERY:%@", self.query);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 20.0f)];
    label.text = @"This is DemoBViewController.";
    [self.view addSubview:label];
}

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl
{
    NSLog(@"Will Open:%@", aUrl.absoluteString);
    return YES;
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
    NSLog(@"Opened From:%@", aUrl.absoluteString);

    if ([aUrl.host isEqualToString:@"demo"]) {
        [self performSelector:@selector(backToInitialStatus) withObject:nil afterDelay:3.0f];
    }
}

@end
