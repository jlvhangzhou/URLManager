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

@property (assign, nonatomic) BOOL                          leftAvailable;
@property (assign, nonatomic) BOOL                          rightAvailable;

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

@synthesize leftAvailable           = _leftAvailable;
@synthesize rightAvailable          = _rightAvailable;

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
    
    if ([self.navigator URLAvailable:[self leftViewControllerURL]]
        || [self.navigator URLAvailable:[self rightViewControllerURL]]) {
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
    // Max width the view slide to right.
    return self.view.width - 44.0f;
}
- (CGFloat)rightViewWidth
{
    // Max width the view slide to left.
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

    if(recognizer.state == UIGestureRecognizerStateEnded) { // end slide.
        [UIView beginAnimations:[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]] context:NULL];

        if (0 < velocity.x) { // left to right.
            if (self.leftAvailable &&
                (([self leftViewWidth] / 3 + offset < self.center.x + translation.x)
                 || (500.0f < velocity.x && offset < self.center.x + translation.x))) { // center to right, more than 1/3 left view width.
                    [UIView setAnimationDuration:0.5f * translation.x / [self leftViewWidth]];
                    self.view.left = self.view.width - right;
                    [self.leftViewController openedFromViewControllerWithURL:self.url];
            }
            else if (500.0f >= velocity.x && offset - 2 * [self rightViewWidth] / 3 > self.center.x + translation.x) { // left to center, less than 1/3 right view width.
                [UIView setAnimationDuration:0.5f * translation.x / [self rightViewWidth]];
                self.view.right = left;
            }
            else { // left to center, more than 1/3 right view width, center to right, less than 1/3 left view width.
                [UIView setAnimationDuration:0.5f * translation.x / [self rightViewWidth]];
                self.view.centerX = offset;
                if (self.rightAvailable) {
                    [self openedFromViewControllerWithURL:self.rightViewController.url];
                }
                [self.leftViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5f];
                [self.rightViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5f];
                self.leftAvailable = NO;
                self.rightAvailable = NO;
            }
        }
        else { // right to left.
            if (self.rightAvailable &&
                ((offset - [self rightViewWidth] / 3 > self.center.x + translation.x)
                || (-500.0f > velocity.x && offset > self.center.x + translation.x))) { // center to left, more than 1/3 right view width.
                    [UIView setAnimationDuration:0.5f * translation.x / [self rightViewWidth]];
                    self.view.right = left;
                    [self.rightViewController openedFromViewControllerWithURL:self.url];
            }
            else if (-500.0f <= velocity.x && offset + 2 * [self leftViewWidth] / 3 < self.center.x + translation.x) { // right to center, less than 1/3 left view width.
                [UIView setAnimationDuration:0.5f * translation.x / [self leftViewWidth]];
                self.view.left = self.view.width - right;
            }
            else { // center to left, less than 1/3 right view width, right to center, more than 1/3 left view width.
                [UIView setAnimationDuration:0.5f * translation.x / [self leftViewWidth]];
                self.view.centerX = offset;
                if (self.leftAvailable) {
                    [self openedFromViewControllerWithURL:self.leftViewController.url];
                }
                [self.leftViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5f];
                [self.rightViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5f];
                self.leftAvailable = NO;
                self.rightAvailable = NO;
            }
        }

        [UIView commitAnimations];

        self.center = self.view.center;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged) { // sliding.
        if (offset <= self.view.center.x && 0 < velocity.x) {
            if (! (self.leftAvailable || self.rightAvailable)) {
                if ([self shouldOpenViewControllerWithURL:[self leftViewControllerURL]]) {
                    self.leftAvailable = YES;
                    self.rightAvailable = NO;

                    if (nil == self.leftViewController) {
                        self.leftViewController = [self.navigator viewControllerForURL:[self leftViewControllerURL] withQuery:nil];
                    }
                    if (! [self.navigator.view.subviews containsObject:self.leftViewController.view]) {
                        [self.navigator.view insertSubview:self.leftViewController.view belowSubview:self.view];
                        [self.navigator.view sendSubviewToBack:self.leftViewController.view];
                    }
                }
            }
        }
        else if (offset - [self rightViewWidth] == self.view.center.x && 0 < velocity.x) {
            if ([self.rightViewController shouldOpenViewControllerWithURL:self.url]) {
                ;;
            }
        }
        else if (offset >= self.view.center.x && 0 > velocity.x) {
            if (! (self.leftAvailable || self.rightAvailable)) {
                if ([self shouldOpenViewControllerWithURL:[self rightViewControllerURL]]) {
                    self.leftAvailable = NO;
                    self.rightAvailable = YES;
                    
                    if (nil == self.rightViewController) {
                        self.rightViewController = [self.navigator viewControllerForURL:[self rightViewControllerURL] withQuery:nil];
                    }
                    if (! [self.navigator.view.subviews containsObject:self.rightViewController.view]) {
                        [self.navigator.view insertSubview:self.rightViewController.view belowSubview:self.view];
                        [self.navigator.view sendSubviewToBack:self.rightViewController.view];
                    }
                }
            }
        }
        else if (offset + [self leftViewWidth] == self.view.center.x && 0 > velocity.x) {
            if ([self.leftViewController shouldOpenViewControllerWithURL:self.url]) {
                ;;
            }
        }
        
        
        if (self.leftAvailable) { // left view only.
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
        else if (self.rightAvailable) { // right view only.
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
    }
}

@end
