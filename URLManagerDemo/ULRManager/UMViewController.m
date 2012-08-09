//
//  UMViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMViewController.h"
#import "UMTools.h"

@interface UMViewController ()

@end

@implementation UMViewController

@synthesize umUrl           = _umUrl;
@synthesize navigator       = _navigator;
@synthesize params          = _params;
@synthesize query           = _query;

#pragma mark - init

- (id)initWithURL:(NSURL *)aUrl
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.umUrl = aUrl;
        self.params = [aUrl params];
    }
    return self;
}

- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)aQuery {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.umUrl = aUrl;
        self.params = [aUrl params];
        self.query = aQuery;
    }
    return self;
}

#pragma mark - before / after open

- (BOOL)willOpenViewControllerWithURL:(NSURL *)aUrl
{
    return YES;
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
}

@end
