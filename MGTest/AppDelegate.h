//
//  AppDelegate.h
//  MGTest
//
//  Created by Esteban.
//  Copyright (c) 2012 Mobgen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGImageTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) MGImageTableViewController *viewController;
@property (retain, nonatomic) UINavigationController *navigationController;

@end
