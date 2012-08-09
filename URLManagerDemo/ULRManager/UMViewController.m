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
@property (assign, nonatomic) CGPoint                       startPoint;

@end

@implementation UMViewController

@synthesize url                 = _url;
@synthesize navigator           = _navigator;
@synthesize params              = _params;
@synthesize query               = _query;

@synthesize startPoint          = _startPoint;
@synthesize panRecognizer       = _panRecognizer;

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
    if ([self shouldSlideToLeft] || [self shouldSlideToRight]) {
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

- (BOOL)shouldSlideToRight
{
    return NO;
}

- (BOOL)shouldSlideToLeft
{
    return NO;
}

#pragma mark - pan recognizer

- (void)addPanRecognizer
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanAction:)];
    [self.view addGestureRecognizer:self.panRecognizer];
    self.startPoint = CGPointMake(self.view.left, self.view.top);
}

- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];

    if(recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended tpnt:%f, %f", translation.x, translation.y);
        NSLog(@"ended vpnt:%f, %f", velocity.x, velocity.y);
        self.startPoint = CGPointMake(self.view.left, self.view.top);
        
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

    }
    else if(recognizer.state == UIGestureRecognizerStateChanged) {
        self.view.left = self.startPoint.x + translation.x;
        
        NSLog(@"changed tpnt:%f, %f", translation.x, translation.y);
        NSLog(@"changed vpnt:%f, %f", velocity.x, velocity.y);
    }
}

@end
