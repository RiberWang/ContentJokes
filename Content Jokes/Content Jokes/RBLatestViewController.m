//
//  RBPopularActivitiesViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-2-27.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBLatestViewController.h"
#import "RBLatestDetailViewController.h"
#import "RBAgoDetailViewController.h"
#import "RBAgoCell.h"

@interface RBLatestViewController () <UIScrollViewDelegate> {
    UIScrollView *_scrollView; // 滚动视图 添加最新和往期两个tableView
    UILabel *_selectLabel; // button选中后下面的红色标识
}

@property (nonatomic, assign) NSInteger requestTag; // 通过这个tag值来判断选中的button状态 因为每次点击button进行请求的时候 tableView就进行了刷新 根据这个tag值(根据网址不同)来区分是哪个请求, 从而判断button的选中状态

@end

@implementation RBLatestViewController

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
    
    self.view.backgroundColor = RGB(234, 234, 234);
    [self setUrl];
    [self startRequestLatest];
}

#pragma mark - 创建按钮
- (void)createNavBarItem {
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 44);
    [btn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    // 最新按钮
    UIButton *latestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    latestButton.frame = CGRectMake(0, 0, WINDOW_SIZE.width/2, 40);
    [latestButton setTitle:@"最新" forState:UIControlStateNormal];
    [latestButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [latestButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [latestButton addTarget:self action:@selector(popularyActivitiesClick:) forControlEvents:UIControlEventTouchUpInside];
    latestButton.tag = 100;
    latestButton.titleLabel.font = [UIFont systemFontOfSize:15];
    latestButton.selected = YES;
    [self.view addSubview:latestButton];
    
    // 往期按钮
    UIButton *agoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agoButton.frame = CGRectMake(WINDOW_SIZE.width/2, 0, WINDOW_SIZE.width/2, 40);
    [agoButton setTitle:@"往期" forState:UIControlStateNormal];
    [agoButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [agoButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    agoButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [agoButton addTarget:self action:@selector(popularyActivitiesClick:) forControlEvents:UIControlEventTouchUpInside];
    agoButton.tag = 101;
    [self.view addSubview:agoButton];
    
    UILabel *divideLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(WINDOW_SIZE.width/2, 5, 1, 40-2*5)];
    divideLineLabel.backgroundColor = [UIColor lightGrayColor];
    divideLineLabel.alpha = 0.2;
    [latestButton addSubview:divideLineLabel];
    
#warning 在这里写达不到预期的效果 已解决 父类中有相同的方法 调用了多次
    // 选中button的状态label
    _selectLabel = [[UILabel alloc] init];
    _selectLabel.frame = CGRectMake(0, 40-2, WINDOW_SIZE.width/2, 2);
    _selectLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:_selectLabel];
}

- (void)leftBackButton:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建滚动视图和表格视图
- (void)createUI {
    // 初始化数据源
    _latestArray = [[NSMutableArray alloc] init];
    _agoArray = [[NSMutableArray alloc] init];
    
    // 滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, WINDOW_SIZE.width, WINDOW_SIZE.height-64-40)];
    _scrollView.contentSize = CGSizeMake(WINDOW_SIZE.width*2, 0);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    // 表格视图 有两个tableView以上时 要设置这个属性和contentInset这个属性(表格的样式为分组样式) 让表格的纵坐标从父视图的(0, 0)坐标开始 否则表格的头部会出现一片空白区域 解决办法:_latestTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _latestTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height-64-40+36) style:UITableViewStyleGrouped];
    _latestTableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _latestTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    _latestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _latestTableView.tag = 326;
    _latestTableView.delegate = self;
    _latestTableView.dataSource = self;
    [_scrollView addSubview:_latestTableView];
    
    _agoTableView = [[UITableView alloc] initWithFrame:CGRectMake(WINDOW_SIZE.width, 0, WINDOW_SIZE.width, WINDOW_SIZE.height-64-40) style:UITableViewStylePlain];
    _agoTableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _agoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _agoTableView.tag = 327;
    _agoTableView.delegate = self;
    _agoTableView.dataSource = self;
    [_scrollView addSubview:_agoTableView];
}

#pragma mark - 按钮的点击事件
- (void)popularyActivitiesClick:(UIButton *)button {
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.selected = NO;
        }
    }
    
    // 这样写不行
    //button.selected = YES;

    // 让label执行动画
    [UIView animateWithDuration:0.5 animations:^{
           _selectLabel.frame = CGRectMake((button.tag-100)*WINDOW_SIZE.width/2, 40-2, WINDOW_SIZE.width/2, 2);
    }];
    // 滚动视图的偏移量改变
    _scrollView.contentOffset = CGPointMake((button.tag-100)*WINDOW_SIZE.width, 0);
    
    UIButton *latestBtn = (UIButton *)[self.view viewWithTag:100];
    UIButton *agoBtn = (UIButton *)[self.view viewWithTag:101];
    if (button.tag == 100) {
        latestBtn.selected = YES;
        agoBtn.selected = NO;
        [self setUrl];
        [self startRequestLatest];
    } else {
        latestBtn.selected = NO;
        agoBtn.selected = YES;
        [self startRequestAgo];
    }
}

#pragma mark - 解析数据-最新
- (void)startRequestLatest {
    [RBMyConnection connectionWithUrl:self.url andFinishBlock:^(NSData *data) {
        [self endRequestLatest:data];
    } andFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

#pragma mark - 设置最新页面的网址
- (void)setUrl {
    NSTimeInterval max_time = [[NSDate date] timeIntervalSince1970];
    self.url = [NSString stringWithFormat:FIND_PATH_LATEST, 0,(int)max_time, FIND_PATH_LATEST_PART];
}

- (void)endRequestLatest:(NSData *)data {
    [_latestArray removeAllObjects];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *firstDataDic = dic[@"data"];
    
    // 将activity字典中的数据填充到模型
    NSDictionary *activityDic = firstDataDic[@"activity"];
    _latestModel = [[RBLatestModel alloc] init];
    [_latestModel setValuesForKeysWithDictionary:activityDic];
    NSDictionary *imageDic = activityDic[@"image"];
    _latestModel.url = imageDic[@"url_list"][0][@"url"];
    NSDictionary *userDic = activityDic[@"user"];
    _latestModel.activity_name = userDic[@"name"];
    [_latestArray addObject:_latestModel];
    
    // 将data字典中的数据填充到模型
    for (NSDictionary *secondDataDic in firstDataDic[@"data"]) {
        NSDictionary *groupDic = secondDataDic[@"group"];
        RBContentModel *contentModel = [[RBContentModel alloc] init];
        [contentModel setValuesForKeysWithDictionary:groupDic];
        NSDictionary *userDic = groupDic[@"user"];
        [contentModel setValuesForKeysWithDictionary:userDic];
        
        UIImage *avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userDic[@"avatar_url"]]]];
        contentModel.avatarImage = avatarImage;
        
        [_latestArray addObject:contentModel];
    }

    //self.requestTag = 2;
    [_latestTableView reloadData];
}

#pragma mark - 解析数据-往期
- (void)startRequestAgo {
    self.url = FIND_PATH_AGO;
    [RBMyConnection connectionWithUrl:self.url andFinishBlock:^(NSData *data) {
        [self endRequestAgo:data];
    } andFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)endRequestAgo:(NSData *)data {
    [_agoArray removeAllObjects];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *firstDataDic = dic[@"data"];
    for (NSDictionary *secondDataDic in firstDataDic[@"data"]) {
        RBLatestModel *latestModel = [[RBLatestModel alloc] init];
        [latestModel setValuesForKeysWithDictionary:secondDataDic];
        latestModel.categoryId = secondDataDic[@"id"];
        latestModel.url = secondDataDic[@"image"][@"url_list"][0][@"url"];
        [_agoArray addObject:latestModel];
    }
    [_agoTableView reloadData];
}

#pragma mark - 表格视图协议中的方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 326) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 326) {
        if (section == 0) {
            return 1;
        }

        return _latestArray.count-1;
    }
    return _agoArray.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 326) {
        if (indexPath.section == 0) {
            RBLatestCell *latestCell = [tableView dequeueReusableCellWithIdentifier:@"LATEST"];
            if (latestCell == nil) {
                latestCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBLatestCell class]) owner:self options:nil] firstObject];
            }
            
            // 填充数据
            [latestCell showInLatestCell:_latestModel];
            //动态设置cell中控件的位置
            CGRect frame = latestCell.contentLabel.frame;
            frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:_latestModel.text andLabelWidth:300 andLabelFontSize:12].height);
            latestCell.contentLabel.frame = frame;
                        
            return latestCell;
        }
        RBContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"CONTENT"];
        if (contentCell == nil) {
            contentCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBContentCell class]) owner:self options:nil] lastObject];
        }
        
        // 填充数据
        RBContentModel *contentModel = _latestArray[indexPath.row+1];
        contentCell.titleButton.hidden = NO;
        
        contentCell.netIsConnect = self.netIsAvaild;
        [contentCell showInContentCell:contentModel];
        
        contentCell.contentLabel.text = [NSString stringWithFormat:@"\t\t\t %@", contentModel.content];
        [contentCell.titleButton setTitle:_latestModel.title forState:UIControlStateNormal];
        // 属性字符串添加下划线
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:contentCell.titleButton.currentTitle];
        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [contentCell.titleButton.currentTitle length])];
        contentCell.titleButton.titleLabel.attributedText = string;
        
        //动态设置cell中控件的位置
        CGRect frame = contentCell.contentLabel.frame;
        frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:contentCell.contentLabel.text andLabelWidth:280 andLabelFontSize:15].height);
        contentCell.contentLabel.frame = frame;
        
        //用户详情页
        [contentCell.userInfoButton addTarget:self action:@selector(pushToUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
        contentCell.userInfoButton.tag = [contentModel.user_id intValue];
        [contentCell.userInfoButton setTitle:contentModel.name forState:UIControlStateNormal];
        
        return contentCell;
    }
    
    RBAgoCell *agoCell = [tableView dequeueReusableCellWithIdentifier:@"AGO"];
    if (agoCell == nil) {
        agoCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBAgoCell class]) owner:self options:nil] lastObject];
    }
    
    // 显示数据
    RBLatestModel *latestModel = _agoArray[indexPath.row+1]; // 从第二个数据开始 也就是新的活动不显示 只显示往期(已结束的)的活动 下面传id的时候从第一行开始indexPath
    [agoCell showInAgoCell:latestModel];
    
    return agoCell;
}

#pragma mark - 表格视图的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 左边表格的点击事件
    if (tableView.tag == 326) {
        RBContentModel *contentModel = _latestArray[indexPath.row+1];
        if (indexPath.section == 1) {
            RBLatestDetailViewController *detailVC = [[RBLatestDetailViewController alloc] init];
            detailVC.contentModel = contentModel;
            detailVC.title = _latestModel.title;
            detailVC.textLabelHeight = [RBMixed setLabelFrameAccordingTextContent:contentModel.content andLabelWidth:280 andLabelFontSize:15].height;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    } else { // 右边表格的点击事件
        RBAgoDetailViewController *agoDetail = [[RBAgoDetailViewController alloc] init];
        agoDetail.title = @"活动详情";
        agoDetail.categoryId = [NSString stringWithFormat:@"%@", [_agoArray[indexPath.row+1] categoryId]];
        [self.navigationController pushViewController:agoDetail animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 326) {
        if (indexPath.section == 0) {
            return ceil([RBMixed setLabelFrameAccordingTextContent:_latestModel.text andLabelWidth:300 andLabelFontSize:12].height)+100+20+1+30+5*10;
        }
        RBContentModel *contentModel = _latestArray[indexPath.row+1];
        
        return ceil([RBMixed setLabelFrameAccordingTextContent:contentModel.content andLabelWidth:280 andLabelFontSize:15].height)+20+30+10+20+10+10;//10+20+10+10间隔
    }
    
    return 193;
}

#pragma mark - 自定义表格分区的头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 326) {
        if (section == 1) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, 30)];
            view.tag = 1000;
            // 参加人数
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
            label.text = [NSString stringWithFormat:@"%@人参加", _latestModel.user_count];
            label.font = [UIFont systemFontOfSize:10];
            [view addSubview:label];
            
            // 点击按钮
            UIButton *latestPublishButton = [UIButton buttonWithType:UIButtonTypeCustom];
            latestPublishButton.frame = CGRectMake(WINDOW_SIZE.width-60*2-10-1, 10, 60, 20);
            latestPublishButton.backgroundColor = [UIColor whiteColor];
            [latestPublishButton setTitle:@"新鲜发表" forState:UIControlStateNormal];
            latestPublishButton.titleLabel.font = [UIFont systemFontOfSize:10];
            [latestPublishButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [latestPublishButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            latestPublishButton.tag = 102;
            [latestPublishButton addTarget:self action:@selector(tableHeadViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            latestPublishButton.selected = YES;
            [view addSubview:latestPublishButton];
            
            UIButton *popularChooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            popularChooseButton.frame = CGRectMake(WINDOW_SIZE.width-60-10, 10, 60, 20);
            popularChooseButton.backgroundColor = [UIColor whiteColor];
            [popularChooseButton setTitle:@"热门精选" forState:UIControlStateNormal];
            popularChooseButton.titleLabel.font = [UIFont systemFontOfSize:10];
            [popularChooseButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            if (self.requestTag == 2) {
                [popularChooseButton setSelected:YES];
                latestPublishButton.selected = NO;
            }
            [popularChooseButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            popularChooseButton.tag = 103;
            [popularChooseButton addTarget:self action:@selector(tableHeadViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:popularChooseButton];
            
            return view;
        }
        return nil;
    }
    return nil;
}

#pragma mark - 表格头按钮点击事件
- (void)tableHeadViewButtonClick:(UIButton *)button {
    UIView *view = [_latestTableView viewWithTag:1000];
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.selected = NO;
        }
    }
    button.selected = YES;
    
    NSTimeInterval max_time = [[NSDate date] timeIntervalSince1970];
    self.url = [NSString stringWithFormat:FIND_PATH_LATEST, (int)button.tag-101,(int)max_time, FIND_PATH_LATEST_PART];
    self.requestTag = (int)button.tag-101;
    [self startRequestLatest];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 326) {
        if (section == 0) {
            return 0;
        }
        return 30;
    }
    return 0;
}

#pragma mark -  滚动视图滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        if ((int)_scrollView.contentOffset.x%(int)WINDOW_SIZE.width == 0) {
            int page = (int)_scrollView.contentOffset.x/WINDOW_SIZE.width;
            [UIView animateWithDuration:0.5 animations:^{
                _selectLabel.frame = CGRectMake(page*WINDOW_SIZE.width/2, 40-2, WINDOW_SIZE.width/2, 2);
            }];
            
            UIButton *latestBtn = (UIButton *)[self.view viewWithTag:100];
            UIButton *agoBtn = (UIButton *)[self.view viewWithTag:101];
            // 设置按钮的选中状态
            if (page == 0) {
                latestBtn.selected = YES;
                agoBtn.selected = NO;
                [self setUrl];
                [self startRequestLatest];
            } else {
            
            latestBtn.selected = NO;
            agoBtn.selected = YES;
            [self startRequestAgo];
            }
            
            
#warning 每次结束就刷新页面 无法选中 已解决
            //        for (id obj in self.view.subviews) {
            //            if ([obj isKindOfClass:[UIButton class]]) {
            //                UIButton *btn = (UIButton *)obj;
            ////                page = (int)btn.tag - 100;
            ////                if (btn.tag == page+100) {
            ////                    btn.selected = !btn.selected;
            ////                }
            //                btn.selected = !btn.selected;
            //            }
            //        }
        }
    }
}

@end
