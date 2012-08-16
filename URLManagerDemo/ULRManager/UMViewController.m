//
//  UMViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#define DEFAULT_SLIDE_VC_WIDTH      320.0f - 44.0f

#import "UMViewController.h"
#import "UMTools.h"

@interface UMViewController ()

- (void)addPanRecognizer;
- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer;

- (void)addShadow;
- (void)initialStatus;

@property (strong, nonatomic) UIPanGestureRecognizer        *panRecognizer;
@property (assign, nonatomic) CGPoint                       center;

@property (strong, nonatomic) UMViewController              *leftViewController;
@property (strong, nonatomic) UMViewController              *rightViewController;

@property (assign, nonatomic) BOOL                          leftAvailable;
@property (assign, nonatomic) BOOL                          rightAvailable;

@property (assign, nonatomic) CGFloat                       leftWidth;
@property (assign, nonatomic) CGFloat                       rightWidth;

@property (strong, nonatomic) NSURL                         *leftURL;
@property (strong, nonatomic) NSURL                         *rightURL;

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

@synthesize slideDelegate           = _slideDelegate;

@synthesize leftWidth               = _leftWidth;
@synthesize rightWidth              = _rightWidth;

@synthesize leftURL                 = _leftURL;
@synthesize rightURL                = _rightURL;

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
    
    if ([self.slideDelegate respondsToSelector:@selector(leftViewControllerURL)]
        && [self.navigator URLAvailable:[self.slideDelegate leftViewControllerURL]]) {
        self.leftURL = [self.slideDelegate leftViewControllerURL];
    }
    if ([self.slideDelegate respondsToSelector:@selector(rightViewControllerURL)]
        && [self.navigator URLAvailable:[self.slideDelegate rightViewControllerURL]]) {
        self.rightURL = [self.slideDelegate rightViewControllerURL];
    }
    [self addPanRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self initialStatus];
}

#pragma mark - before / after open

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl
{
    return YES;
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
}

#pragma mark - pan recognizer

- (void)addPanRecognizer
{
    if (self.leftURL || self.rightURL) {
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanAction:)];
        [self.view addGestureRecognizer:self.panRecognizer];
        self.center = self.view.center;
    }
}

- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];

    CGFloat offset = self.view.width / 2;
    self.leftWidth = (self.slideDelegate && [self.slideDelegate respondsToSelector:@selector(leftViewWidth)])
    ? [self.slideDelegate leftViewWidth]
    : DEFAULT_SLIDE_VC_WIDTH;
    self.rightWidth = (self.slideDelegate && [self.slideDelegate respondsToSelector:@selector(rightViewWidth)])
    ? [self.slideDelegate rightViewWidth]
    : DEFAULT_SLIDE_VC_WIDTH;

    CGFloat left = self.view.width - self.rightWidth;
    CGFloat right = self.view.width - self.leftWidth;

    if(recognizer.state == UIGestureRecognizerStateEnded) { // end slide.
        [UIView beginAnimations:[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]] context:NULL];
        
        CGFloat animationDuration = 0.0f;

        if (0 < velocity.x) { // left to right.
            if (self.leftAvailable &&
                ((self.leftWidth / 3 + offset < self.center.x + translation.x)
                 || (500.0f < velocity.x && offset < self.center.x + translation.x))) { // center to right, more than 1/3 left view width.
                    animationDuration = 0.5f * translation.x / self.leftWidth;
                    [UIView setAnimationDuration:animationDuration];
                    self.view.left = self.view.width - right;
                    if (self.center.x == offset) {
                        [self.leftViewController openedFromViewControllerWithURL:self.url];
                    }
            }
            else if (500.0f >= velocity.x && offset - 2 * self.rightWidth / 3 > self.center.x + translation.x) { // left to center, less than 1/3 right view width.
                animationDuration = 0.5f * translation.x / self.rightWidth;
                [UIView setAnimationDuration:animationDuration];
                self.view.right = left;
            }
            else { // left to center, more than 1/3 right view width, center to right, less than 1/3 left view width.
                animationDuration = 0.5f * translation.x / self.rightWidth;
                [UIView setAnimationDuration:animationDuration];
                
                if (self.rightAvailable && offset != self.center.x) {
                    [self openedFromViewControllerWithURL:self.rightViewController.url];
                }
                self.view.centerX = offset;
                self.leftAvailable = NO;
                self.rightAvailable = NO;
            }
        }
        else { // right to left.
            if (self.rightAvailable &&
                ((offset - self.rightWidth / 3 > self.center.x + translation.x)
                || (-500.0f > velocity.x && offset > self.center.x + translation.x))) { // center to left, more than 1/3 right view width.
                    animationDuration = 0.5f * translation.x / self.rightWidth;
                    [UIView setAnimationDuration:animationDuration];
                    self.view.right = left;
                    if (self.center.x == offset) {
                        [self.rightViewController openedFromViewControllerWithURL:self.url];
                    }
            }
            else if (-500.0f <= velocity.x && offset + 2 * self.leftWidth / 3 < self.center.x + translation.x) { // right to center, less than 1/3 left view width.
                animationDuration = 0.5f * translation.x / self.leftWidth;
                [UIView setAnimationDuration:animationDuration];
                self.view.left = self.view.width - right;
            }
            else { // center to left, less than 1/3 right view width, right to center, more than 1/3 left view width.
                animationDuration = 0.5f * translation.x / self.leftWidth;
                [UIView setAnimationDuration:animationDuration];

                if (self.leftAvailable && offset != self.center.x) {
                    [self openedFromViewControllerWithURL:self.leftViewController.url];
                }
                self.view.centerX = offset;
                self.leftAvailable = NO;
                self.rightAvailable = NO;
            }
        }

        [UIView commitAnimations];

        self.center = self.view.center;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged) { // sliding.
        UIView *transitionView = self.view.superview;
        if (offset <= self.view.centerX && 0 < velocity.x) {
            if (! (self.leftAvailable || self.rightAvailable)) {
                if ([self shouldOpenViewControllerWithURL:self.leftURL]) {
                    self.leftAvailable = YES;
                    self.rightAvailable = NO;
                    
                    [self addShadow];
                    if ([self.slideDelegate respondsToSelector:@selector(willOpenLeftViewController)]) {
                        [self.slideDelegate willOpenLeftViewController];
                    }
                    [self.leftViewController.view removeFromSuperview];
                    [self.leftViewController removeFromParentViewController];
                    self.leftViewController = nil;
                    [self.rightViewController.view removeFromSuperview];
                    [self.rightViewController removeFromParentViewController];
                    self.rightViewController = nil;

                    self.leftViewController = [self.navigator viewControllerForURL:self.leftURL
                                                                         withQuery:nil];
                    [transitionView insertSubview:self.leftViewController.view
                                    belowSubview:self.view];
                    [transitionView sendSubviewToBack:self.leftViewController.view];
                    self.leftViewController.view.frame = CGRectMake(0.0f, 0.0f,
                                                                    self.leftViewController.view.frame.size.width,
                                                                    self.leftViewController.view.frame.size.height);
                }
            }
        }
        else if (offset - self.rightWidth >= self.view.centerX && 0 < velocity.x) {
            if ([self.rightViewController shouldOpenViewControllerWithURL:self.url]) {
                ;;
            }
        }
        else if (offset >= self.view.centerX && 0 > velocity.x) {
            if (! (self.leftAvailable || self.rightAvailable)) {
                if ([self shouldOpenViewControllerWithURL:self.rightURL]) {
                    self.leftAvailable = NO;
                    self.rightAvailable = YES;
                    
                    [self addShadow];
                    if ([self.slideDelegate respondsToSelector:@selector(willOpenRightViewController)]) {
                        [self.slideDelegate willOpenRightViewController];
                    }
                    [self.leftViewController.view removeFromSuperview];
                    [self.leftViewController removeFromParentViewController];
                    self.leftViewController = nil;
                    [self.rightViewController.view removeFromSuperview];
                    [self.rightViewController removeFromParentViewController];
                    self.rightViewController = nil;

                    self.rightViewController = [self.navigator viewControllerForURL:self.rightURL
                                                                          withQuery:nil];
                    [transitionView insertSubview:self.rightViewController.view
                                    belowSubview:self.view];
                    [transitionView sendSubviewToBack:self.rightViewController.view];
                    self.rightViewController.view.frame = CGRectMake(0.0f, 0.0f,
                                                                    self.rightViewController.view.frame.size.width,
                                                                    self.rightViewController.view.frame.size.height);
                }
            }
        }
        else if (offset + self.leftWidth <= self.view.centerX && 0 > velocity.x) {
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

#pragma mark - self view

- (void)addShadow
{
    if (self.leftAvailable) {
        self.view.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
    }
    else {
        self.view.layer.shadowOffset = CGSizeMake(2.0f, 0.0f);
    }
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 0.3f;
    self.view.layer.shadowRadius = 10.0f;
}

- (void)initialStatus {
    [UIView beginAnimations:[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]] context:NULL];
    [UIView setAnimationDuration:0.5f];

    self.view.left = 0;

    [UIView commitAnimations];

    self.center = self.view.center;
    
    self.leftAvailable = NO;
    self.rightAvailable = NO;
}

@end
