//
//  RBUgcViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-2-2.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBUgcViewController.h"

@interface RBUgcViewController ()

@end

@implementation RBUgcViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 44);
    [btn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)pressBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUrl {
    self.url = [NSString stringWithFormat:UGC_PATH, _userId, UGC_PATH_PART];
    NSLog(@"tougao====%@", self.url);
}

- (void)createUI {
    [super createUI];
    self.tableView.frame = CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height-64);
}

@end
