//
//  RBRepinViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-3.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBRepinViewController.h"

@interface RBRepinViewController ()

@end

@implementation RBRepinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)setUrl {
    self.url = [NSString stringWithFormat:REPIN_PATH, _userId, REPIN_PATH_PART];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDownRefresh:NO];
    [self setUpRefresh:NO];
    [self setNavBarButton:NO];
    [self setUrl];
    [self startRequest];
}

- (void)createNavBarItem {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 44);
    [btn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)createUI {
    [super createUI];
    self.tableView.frame = CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height-64);
}

- (void)pressBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
