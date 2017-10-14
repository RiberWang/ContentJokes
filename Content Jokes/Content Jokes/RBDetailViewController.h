//
//  RBDetailViewController.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-24.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBContentModel.h"
#import "RBImageModel.h"
#import "RBVideoModel.h"

#import "RBDetailCell.h"
#import "RBContentCell.h"//ContentVC和ImageVC共用一个cell
#import "RBVideoCell.h"

#import "RBMixed.h"
#import "RBMyConnection.h"
#import "Header.h"
#import "UIImageView+WebCache.h"

#define WINDOW_SIZE [UIScreen mainScreen].bounds.size
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface RBDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, assign) int textLabelHeight;//接收点击的段子的内容的高度

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *topComArray;//热门评论
@property(nonatomic, strong) NSMutableArray *recentComArray;//新鲜评论
@property(nonatomic, copy) NSString *url;

@property (nonatomic, assign) BOOL netIsAvaild;

- (void)setUrl;
- (void)endRequest:(NSData *)data;

// 进入用户详情页
- (void)gotoUserInfoVC:(UIButton *)button;

@end
