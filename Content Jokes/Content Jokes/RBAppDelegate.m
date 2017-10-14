//
//  RBAppDelegate.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBAppDelegate.h"
#import "RBContentViewController.h"
#import "RBImageViewController.h"
#import "RBVideoViewController.h"
#import "RBFindViewController.h"
#import "RBCheckViewController.h"
#import "RBHelpView.h"
//#import "UMSocial.h"
#import "LeftViewController.h"

@implementation RBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // 设置友盟appKey
    //[UMSocialData setAppKey:@"54b8bc6efd98c5a4e90000d8"];
    
    // 这样写进入详细页导航条会有短暂的白色背景延迟
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:211/255.0 green:208/255.0 blue:196/255.0 alpha:1]];
    
    RBContentViewController *contentVC = [[RBContentViewController alloc] init];
    RBImageViewController *imageVC = [[RBImageViewController alloc] init];
    RBVideoViewController *videoVC = [[RBVideoViewController alloc] init];
    RBFindViewController *findVC = [[RBFindViewController alloc] init];
    RBCheckViewController *checkVC = [[RBCheckViewController alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:contentVC, imageVC, videoVC, findVC, checkVC, nil];
    
    // tabbar上的标题
    NSArray *titleArray = @[@"段子", @"图片", @"视频", @"发现", @"审核"];
    // 要显示图片的标题
    NSArray *imageArray = @[@"article", @"picture", @"video", @"Found", @"audit"];

    for (int i = 0; i < array.count; i++) {
        UIViewController *VC = array[i];
        // 设置导航条
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg.png"] forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        [array replaceObjectAtIndex:i withObject:nav];
        
        // 设置标签栏图片
        nav.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_night.png", imageArray[i]]];
        nav.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_press.png", imageArray[i]]];
        nav.tabBarItem.selectedImage = [nav.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //[nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
        nav.tabBarItem.title = titleArray[i];
    }
    
    // 创建左视图
    LeftViewController *leftViewcontroller = [[LeftViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:leftViewcontroller];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    // 设置导航栏背景颜色
    nav.navigationBar.translucent = NO;
    
    // 创建 tab
    _tabBC = [[UITabBarController alloc] init];
    [_tabBC.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbg.png"]];
    [_tabBC.tabBar setTintColor:[UIColor whiteColor]];
    _tabBC.viewControllers = array;
    
    // 抽屉视图
    _drawer = [[MMDrawerController alloc] initWithCenterViewController:_tabBC leftDrawerViewController:nav];
    [_drawer setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width-50];
    [_drawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    _drawer.shouldStretchDrawer = NO; // 伸缩效果
    _drawer.showsShadow = NO; // 阴影
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"isNotFirst"]) {
        self.window.rootViewController = _drawer;
    } else {

        // 引导页
        RBHelpView *helpView = [[RBHelpView alloc] initWithFrame:self.window.bounds];
        [helpView setClickBlock:^{
            [userDefault setBool:YES forKey:@"isNotFirst"];
            [userDefault synchronize];
        }];
        [_drawer.view addSubview:helpView];
        
        self.window.rootViewController = _drawer;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
