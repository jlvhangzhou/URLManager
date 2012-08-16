//
//  UMgrDemoViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMgrDemoViewController.h"
#import "UMgrAppDelegate.h"

@interface UMgrDemoViewController ()

@end

@implementation UMgrDemoViewController

- (id)initWithURL:(NSURL *)aUrl
{
    self = [super initWithURL:aUrl];
    if (self) {
        self.slideDelegate = self;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10.0f, 10.0f, 300.0f, 44.0f);
    [btn setTitle:@"um://demob/path/aaa/?a=b&c=d" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoDemoB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnB.frame = CGRectMake(10.0f, 64.0f, 300.0f, 44.0f);
    [btnB setTitle:@"um://demob/?a=b with query" forState:UIControlStateNormal];
    [btnB addTarget:self action:@selector(gotoDemoBWithQuery) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnB];
    
    UIButton *btnWeb = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnWeb.frame = CGRectMake(10.0f, 114.0f, 300.0f, 44.0f);
    [btnWeb setTitle:@"um://demoweb" forState:UIControlStateNormal];
    [btnWeb addTarget:self action:@selector(gotoDemoWeb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnWeb];

}

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl
{
    NSLog(@"Will Open:%@", aUrl.absoluteString);
    return YES;
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
    NSLog(@"Opened From:%@", aUrl.absoluteString);
}

- (void)gotoDemoB
{
    [self.navigator openURL:[[NSURL URLWithString:@"um://demob/path/aaa"]
                             addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"va", @"ka",
                                        @"vb", @"kb",
                                        nil]]];
}

- (void)gotoDemoWeb
{
    [self.navigator openURL:[NSURL URLWithString:@"um://demoweb"]];
}

- (void)gotoDemoBWithQuery
{
    [self.navigator openURL:[NSURL URLWithString:@"um://demob/?a=b"]
                  withQuery:[NSDictionary dictionaryWithObjectsAndKeys:
                             [NSArray arrayWithObjects:@"1", @"2", nil], @"q_key", nil]];
}

- (NSURL *)leftViewControllerURL
{
    return [NSURL URLWithString:@"um://demob"];
}

- (NSURL *)rightViewControllerURL
{
    return [NSURL URLWithString:@"um://demoweb"];
}

- (CGFloat)rightViewWidth {
    return 200.0f;
}

- (void)willOpenLeftViewController
{
    NSLog(@"will open left view controller.");
}

@end
