//
//  UMViewController.h
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMNavigator.h"
#import "UMTools.h"

@interface UMViewController : UIViewController {
    NSString            *url;
    CGPoint             center;
    
    UMViewController    *leftViewController;
    UMViewController    *rightViewController;
}

- (id)initWithURL:(NSURL *)aUrl;
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query;

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl;
- (void)openedFromViewControllerWithURL:(NSURL *)aUrl;

- (NSURL *)leftViewControllerURL;
- (NSURL *)rightViewControllerURL;

- (CGFloat)leftViewWidth;
- (CGFloat)rightViewWidth;

@property (strong, nonatomic) NSURL                 *url;
@property (strong, nonatomic) UMNavigator           *navigator;

@property (strong, nonatomic) NSDictionary          *params;
@property (strong, nonatomic) NSDictionary          *query;

@end
