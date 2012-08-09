//
//  UMNavigator.m
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMNavigator.h"
#import "UMViewController.h"

@interface UMNavigator ()

@end

@implementation UMNavigator

@synthesize config          = _config;

#pragma mark - init

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.config = [[NSMutableDictionary alloc] init];

        return self;
    }

    return nil;
}

#pragma mark - life circle

#pragma mark - actions

- (UMViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    Class class = NSClassFromString([self.config objectForKey:urlString]);
    
    UMViewController * viewController = nil;
    
    if (nil == query) {
        viewController = (UMViewController *)[[class alloc] initWithURL:url];
    }
    else {
        viewController = (UMViewController *)[[class alloc] initWithURL:url query:query];
    }
    viewController.navigator = self;
    
    return viewController;
}

- (void)openURL:(NSURL *)url
{
    NSLog(@"open: %@", url.absoluteString);
    UMViewController *lastViewController = (UMViewController *)[self.viewControllers lastObject];
    UMViewController *viewController = [self viewControllerForURL:url withQuery:nil];
    if ([lastViewController shouldOpenViewControllerWithURL:url]) {
        [self pushViewController:viewController animated:YES];
        [viewController openedFromViewControllerWithURL:lastViewController.url];
    }
}

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    NSLog(@"open: %@", url.absoluteString);
    UMViewController *lastViewController = (UMViewController *)[self.viewControllers lastObject];
    UMViewController *viewController = [self viewControllerForURL:url withQuery:query];
    if ([lastViewController shouldOpenViewControllerWithURL:url]) {
        [self pushViewController:viewController animated:YES];
        [viewController openedFromViewControllerWithURL:lastViewController.url];
    }
}

#pragma mark - getter

#pragma mark - config

- (void)setViewControllerName:(NSString *)className forURL:(NSString *)url
{
    if (nil == self.config) {
        self.config = [[NSMutableDictionary alloc] init];
    }
    
    [self.config setValue:className forKey:url];
}

@end
