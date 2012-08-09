//
//  UMgrAppDelegate.h
//  URLManagerDemo
//
//  Created by jiajun on 8/3/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMgrDemoViewController;
@class UMNavigator;

@interface UMgrAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                  *window;
@property (strong, nonatomic) UMgrDemoViewController    *viewController;
@property (strong, nonatomic) UMNavigator               *navigator;

@end
