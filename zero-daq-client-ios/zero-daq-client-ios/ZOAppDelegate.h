//
//  ZOAppDelegate.h
//  zero-daq-client-ios
//
//  Created by Micah Pearlman on 2/18/12.
//  Copyright (c) 2012 Zero Vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZOViewController;

@interface ZOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ZOViewController *viewController;

@end
