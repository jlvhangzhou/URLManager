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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

- (void)gotoDemoB
{
    [self.navigator openURL:[[NSURL URLWithString:@"um://demob/path/aaa"]
                             addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"va", @"ka",
                                        @"vb", @"kb",
                                        nil]]];
}

- (void)gotoDemoBWithQuery
{
    [self.navigator openURL:[NSURL URLWithString:@"um://demob/?a=b"]
                  withQuery:[NSDictionary dictionaryWithObjectsAndKeys:
                             [NSArray arrayWithObjects:@"1", @"2", nil], @"q_key", nil]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
