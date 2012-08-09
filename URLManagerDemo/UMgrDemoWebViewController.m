//
//  UMgrDemoWebViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/9/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMgrDemoWebViewController.h"

@interface UMgrDemoWebViewController ()

@end

@implementation UMgrDemoWebViewController

@synthesize webView             = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (nil == self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
    }
    
    [self.webView loadHTMLString:@"<p><a href=\"um://demob/p/?k=v&kb=vb\">um://demob/p/?k=v&kb=vb<a/></p>" baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([@"um" isEqualToString:request.URL.scheme]) {
        [self.navigator openURL:request.URL];
        return NO;
    }
    else {
        return YES;
    }
}

@end
