//
//  RBPopularActivitiesViewController.h
//  Content Jokes
//
//  Created by qianfeng on 15-2-27.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBBaseTableViewController.h"
#import "RBLatestCell.h"
#import "RBContentCell.h"
#import "RBLatestModel.h"
#import "RBContentModel.h"

@interface RBLatestViewController : RBBaseTableViewController

// 作为属性公开接口方便页面继承
@property(nonatomic, strong) UITableView *latestTableView; // 最新
@property(nonatomic, strong) UITableView *agoTableView; // 往期
@property(nonatomic, strong) NSMutableArray *latestArray; // 最新tableView的数据源
@property(nonatomic, strong) NSMutableArray *agoArray; // 往期tableView的数据源
@property(nonatomic, strong) RBLatestModel *latestModel;

- (void)leftBackButton:(UIButton *)btn;

@end
