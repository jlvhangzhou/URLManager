//
//  UMNavigator.h
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMViewController;

@interface UMNavigator : NSObject
{
    UIView          *view;
}

- (id)initWithNavigationController:(UINavigationController *)controller;
- (id)initWithRootViewController:(UIViewController *)viewController;

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query;
- (void)openURL:(NSURL *)url;

- (UMViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query;

- (UIView *)view;

- (void)setViewControllerName:(NSString *)className forURL:(NSString *)url;

@property (strong, nonatomic) UINavigationController            *navigationController;
@property (strong, nonatomic) NSMutableDictionary               *umConfig;

@end
