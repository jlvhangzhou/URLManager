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
    NSString           *url;
}

- (id)initWithURL:(NSURL *)aUrl;
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query;

@property (strong, nonatomic) NSURL                 *umUrl;
@property (strong, nonatomic) UMNavigator           *navigator;

@property (strong, nonatomic) NSDictionary          *params;
@property (strong, nonatomic) NSDictionary          *query;

@end
