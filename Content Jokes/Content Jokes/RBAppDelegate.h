//
//  RBAppDelegate.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface RBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBC;
@property (nonatomic, strong) MMDrawerController *drawer;
@end
