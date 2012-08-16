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
#import <QuartzCore/QuartzCore.h>

@protocol UMSlideDelegate <NSObject>

@optional
- (NSURL *)leftViewControllerURL;
- (NSURL *)rightViewControllerURL;

- (CGFloat)leftViewWidth;
- (CGFloat)rightViewWidth;

- (void)willOpenLeftViewController;
- (void)willOpenRightViewController;

@end

@interface UMViewController : UIViewController {
    NSString                *url;
    CGPoint                 center;
    
    UMViewController        *leftViewController;
    UMViewController        *rightViewController;
    
    BOOL                    leftAvailable;
    BOOL                    rightAvailable;
    
    id<UMSlideDelegate>     slideDelegate;
    
    CGFloat                 leftWidth;
    CGFloat                 rightWidth;
    
    NSURL                   *leftURL;
    NSURL                   *rightURL;
}

- (id)initWithURL:(NSURL *)aUrl;
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query;

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl;
- (void)openedFromViewControllerWithURL:(NSURL *)aUrl;

@property (strong, nonatomic) NSURL                 *url;
@property (strong, nonatomic) UMNavigator           *navigator;

@property (strong, nonatomic) NSDictionary          *params;
@property (strong, nonatomic) NSDictionary          *query;

@property (assign, nonatomic) id<UMSlideDelegate>   slideDelegate;

@end
