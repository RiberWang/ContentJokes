//
//  RBBaseTableViewController.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBBaseViewController.h"
#import "RBContentCell.h"
#import "RBMixed.h"
#import "RBUserInfoViewController.h"
#import "PopoverView.h"
#import "MJRefresh.h"
#import "RBDBManager.h" // 数据库管理类
#import "Reachability.h" // 有没有网络

@interface RBBaseTableViewController : RBBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *dataSources;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, strong) UIButton *refreshBtn; // 刷新按钮

// 网址需要 标识
@property(nonatomic, copy) NSString *category_id; // 判断点击的是段子 图片 还是视频
@property(nonatomic, copy) NSString *level; // 判断点击的是推荐 热门 精华 新鲜按钮

@property (nonatomic, strong) RBDBManager *manager; //数据库管理类


@property (nonatomic, assign) BOOL isDown;//判断是下拉还是上拉
@property (nonatomic, assign) BOOL isDownRefresh;//是否正在下拉刷新

#pragma mark - UI
//重写tableView tableView的样式不同
- (void)createUI;

// 设置导航上的推荐和投稿按钮
- (void)setNavBarButton:(BOOL)isNeed;

// 设置刷新按钮的坐标
- (void)createRefreshBtn;

#pragma mark - 刷新
- (void)setUrl;

//设置是否需要下拉刷新 如果需要就有刷新功能
- (void)setDownRefresh:(BOOL)isNeedDownRefresh;
//开始下拉刷新
- (void)starDownRefresh;

//设置是否需要上拉刷新 如果需要就有刷新功能
- (void)setUpRefresh:(BOOL)isNeedUpRefresh;

//开始刷新 刚进入页面是否刷新
- (void)setBeginRefresh:(BOOL)isBegin;

//结束刷新
- (void)endRefresh;

#pragma mark - 请求
//如果没有刷新 就直接调用这个方法
- (void)startRequest; // 后边部分需要多次请求

//解析请求到的数据
- (void)endRequestWithData:(NSData *)data;

#pragma mark - 数据源
//判断是下拉还是上拉 数据源添加数据
- (void)dataSourcesAddModel:(id)obj;

#pragma mark - 点击事件
// 头部视图的点击事件
- (void)titleButtonClick:(UIButton *)button;

#pragma mark - 进入用户详情页
// 这里其实公开接口只是解决警告 不需要重写这个方法
- (void)pushToUserInfoVC:(UIButton *)btn;

@end
