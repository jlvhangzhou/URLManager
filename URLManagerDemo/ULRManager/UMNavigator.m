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

@property (strong, nonatomic) UIView                            *view;

@end

@implementation UMNavigator

@synthesize umConfig        = _umConfig;
@synthesize view            = _view;

#pragma mark - init

- (id)initWithRootViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.umConfig = [[NSMutableDictionary alloc] init];

        return self;
    }

    return nil;
}

- (id)initWithNavigationController:(UINavigationController *)controller
{
    self = [super init];
    if (self) {
        self.navigationController = controller;
        self.umConfig = [[NSMutableDictionary alloc] init];
        
        return self;
    }

    return nil;
}

#pragma mark - actions

- (UMViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    Class class = NSClassFromString([self.umConfig objectForKey:urlString]);
    
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
    if (self.navigationController) {
        NSLog(@"open: %@", url.absoluteString);
        UMViewController *viewController = [self viewControllerForURL:url withQuery:nil];
        [self.navigationController pushViewController:viewController
                                                    animated:YES];
    }
}

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    if (self.navigationController) {
        NSLog(@"open: %@", url.absoluteString);
        UMViewController *viewController = [self viewControllerForURL:url withQuery:query];
        [self.navigationController pushViewController:viewController
                                             animated:YES];
    }
}

#pragma mark - getter

- (UIView *)view
{
    return self.navigationController.view;
}

#pragma mark - config

- (void)setViewControllerName:(NSString *)className forURL:(NSString *)url
{
    if (nil == self.umConfig) {
        self.umConfig = [[NSMutableDictionary alloc] init];
    }
    
    [self.umConfig setValue:className forKey:url];
}

@end
