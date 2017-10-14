//
//  RBBaseViewController.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBMyConnection.h"
#import "Header.h"
#import "UIImageView+WebCache.h"
#import "RBCommonSave.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

#define WINDOW_SIZE [UIScreen mainScreen].bounds.size
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface RBBaseViewController : UIViewController<NSURLConnectionDataDelegate, MBProgressHUDDelegate>

@property (nonatomic, assign) BOOL netIsAvaild;

@property (nonatomic, strong) MBProgressHUD *progressHud;

- (void)createNavBarItem;

// 监测网络
- (BOOL)updateInterfaceWithReachability:(Reachability *)reachability;

// hud
-(void)beginWaiting:(NSString *)message mode:(MBProgressHUDMode)mode;
-(void)beginWaiting:(NSString *)message;
-(void)endWaiting:(int)time;
-(void)endWaiting;

// 复制文本内容提示
- (void)copyContentsAlertLable;

@end
