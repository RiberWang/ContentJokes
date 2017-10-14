//
//  RBBaseViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBBaseViewController.h"
#import "RBUserInfoViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "RBAppDelegate.h"

@interface RBBaseViewController ()

@end

@implementation RBBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavBarItem];
    
//    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:self.progressHud];
//    self.progressHud.delegate = self;
//    self.progressHud.square = NO;
//    [self.progressHud show:YES];
    
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)networkChanged:(NSNotification *)notification {
    Reachability *currentReach = [notification object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:currentReach];
}

- (BOOL)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
        {
           self.netIsAvaild = NO;
        }
            break;
        case ReachableViaWWAN:
        {
            self.netIsAvaild = YES;
        }
            break;
        case ReachableViaWiFi:
        {
            self.netIsAvaild = YES;
        }
            break;
        default:
            break;
    }
    
    return self.netIsAvaild;
}

- (void)createNavBarItem {
    self.view.backgroundColor = RGB(234, 234, 234);
    
    //创建导航上的用户头像 左侧按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"defaulthead.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    //使用户头像按钮的点击的范围变小
    UIButton *leftSpaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftSpaceBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithCustomView:leftSpaceBtn];
    self.navigationItem.leftBarButtonItems = @[leftItem, leftSpaceItem];
}

- (void)buttonClick:(id)button {
   RBAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)beginWaiting:(NSString *)message
{
    if (self.progressHud) {
        self.progressHud.labelText = message;
        self.progressHud.delegate = self;
        self.progressHud.square = NO;
        [self.progressHud show:YES];
    } else {
        self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.progressHud];
        self.progressHud.delegate = self;
        self.progressHud.labelText = message;
        self.progressHud.square = NO;
        [self.progressHud show:YES];
    }
}

-(void)beginWaiting:(NSString *)message mode:(MBProgressHUDMode)mode
{
    if (self.progressHud) {
        self.progressHud.labelText = message;
        self.progressHud.mode = mode;

    } else {
        self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.progressHud];
        self.progressHud.delegate = self;
        self.progressHud.mode = mode;
        self.progressHud.labelText = message;
        self.progressHud.square = NO;
        [self.progressHud show:YES];
    }
}

-(void)endWaiting:(int)time
{
    if (self.progressHud) {
        [self.progressHud hide:YES afterDelay:time];
        self.progressHud = nil;
    }
}

-(void)endWaiting
{
    if (self.progressHud) {
        [self.progressHud hide:YES afterDelay:.5];
        self.progressHud = nil;
    }
}

- (void)copyContentsAlertLable {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((WINDOW_SIZE.width-60)/2.0, (WINDOW_SIZE.height-94)/2.0, 60, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"复制成功";
    [self.view addSubview:label];
    
    [self performSelector:@selector(copyLabelRemove:) withObject:label afterDelay:1];
}

- (void)copyLabelRemove:(UILabel *)label {
    [label removeFromSuperview];
}
    
@end
