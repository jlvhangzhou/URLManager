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

- (void)addPanRecognizer;
- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer;

@property (strong, nonatomic) UIPanGestureRecognizer        *panRecognizer;
@property (assign, nonatomic) CGPoint                       center;

@property (strong, nonatomic) UMViewController              *leftViewController;
@property (strong, nonatomic) UMViewController              *rightViewController;

@end

@implementation UMViewController

@synthesize url                     = _url;
@synthesize navigator               = _navigator;
@synthesize params                  = _params;
@synthesize query                   = _query;

@synthesize center                  = _center;
@synthesize panRecognizer           = _panRecognizer;

@synthesize leftViewController      = _leftViewController;
@synthesize rightViewController     = _rightViewController;

#pragma mark - init

- (id)initWithURL:(NSURL *)aUrl
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.url = aUrl;
        self.params = [aUrl params];
    }
    return self;
}

- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)aQuery {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.url = aUrl;
        self.params = [aUrl params];
        self.query = aQuery;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rightViewController = [self.navigator viewControllerForURL:[self rightViewControllerURL] withQuery:nil];
    self.leftViewController = [self.navigator viewControllerForURL:[self leftViewControllerURL] withQuery:nil];

    if (self.leftViewController || self.rightViewController) {
        [self addPanRecognizer];
    }
}

#pragma mark - before / after open

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl
{
    return YES;
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
}

#pragma mark - slide or not

- (UMViewController *)leftViewControllerURL
{
    return nil;
}

- (UMViewController *)rightViewControllerURL
{
    return nil;
}

- (CGFloat)leftViewWidth
{
    return self.view.width - 44.0f;
}
- (CGFloat)rightViewWidth
{
    return self.view.width - 44.0f;
}

#pragma mark - pan recognizer

- (void)addPanRecognizer
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanAction:)];
    [self.view addGestureRecognizer:self.panRecognizer];
    self.center = self.view.center;
}

- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];

    CGFloat offset = self.view.width / 2;
    CGFloat left = self.view.width - [self rightViewWidth];
    CGFloat right = self.view.width - [self leftViewWidth];

    if(recognizer.state == UIGestureRecognizerStateEnded) {
        if (0 < velocity.x) {
            if (([self leftViewWidth] / 3 + offset < self.center.x + translation.x)
                || (500.0f < velocity.x && offset < self.center.x + translation.x)) {
                self.view.left = self.view.width - right;
            }
            else if (500.0f >= velocity.x && offset - 2 * [self rightViewWidth] / 3 > self.center.x + translation.x) {
                self.view.right = left;
            }
            else {
                self.view.centerX = offset;
            }
        }
        else {
            if ((offset - [self rightViewWidth] / 3 > self.center.x + translation.x)
                || (-500.0f > velocity.x && offset > self.center.x + translation.x)) {
                self.view.right = left;
            }
            else if (-500.0f <= velocity.x && offset + 2 * [self leftViewWidth] / 3 < self.center.x + translation.x) {
                self.view.left = self.view.width - right;
            }
            else {
                self.view.centerX = offset;
            }
        }

        
//        if (0 > translation.x) {
//            self.view.left = 0.0f;
//        }else if (translation.x <= self.view.width) {
//            if (translation.x >= self.view.width / 2.0f || velocity.x > 500.0f) {
////                [self back];
//            }else {
//                [UIView beginAnimations:[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]] context:NULL];
//                [UIView setAnimationDuration:0.5f * translation.x / self.view.width];
//                self.view.left = 0.0f;
//                [UIView commitAnimations];
//            }
//        }else {
////            [self back];
//        }
        self.center = self.view.center;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.leftViewController && ! self.rightViewController) {
            if (offset > self.center.x + translation.x) {
                self.view.left = 0.0f;
            }
            else if (offset <= self.center.x + translation.x
                     && self.view.width - right + offset >= self.center.x + translation.x) {
                self.view.centerX = self.center.x + translation.x;
            }
            else {
                self.view.left = self.view.width - right;
            }
        }
        else if (! self.leftViewController && self.rightViewController) {
            if (self.view.width - offset <= self.center.x + translation.x) {
                self.view.right = self.view.width;
            }
            else if (self.view.width - offset >= self.center.x + translation.x
                     && left - offset <= self.center.x + translation.x) {
                self.view.centerX = self.center.x + translation.x;
            }
            else {
                self.view.right = left;
            }
        }
        else if (self.leftViewController && self.rightViewController) {
            if (left - offset > self.center.x + translation.x) {
                self.view.right = left;
            }
            else if (self.view.width + offset - right < self.center.x + translation.x) {
                self.view.left = self.view.width - right;
            }
            else {
                self.view.centerX = self.center.x + translation.x;
            }
        }
    }
}

@end
