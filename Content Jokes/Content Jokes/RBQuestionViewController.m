//
//  RBQuestionViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-29.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBQuestionViewController.h"

@interface RBQuestionViewController () {
    UIWebView *_webView;
}

@end

@implementation RBQuestionViewController

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
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    // 设置webView的背景
    _webView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.view addSubview:_webView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 44);
    [btn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:QUESTION_PATH]];
    [_webView loadRequest:request];
}

- (void)leftBackButton:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewWillAppear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = YES;
//}

@end
