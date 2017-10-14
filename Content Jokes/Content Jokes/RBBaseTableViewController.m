//
//  RBBaseTableViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBBaseTableViewController.h"
#import "RBUserInfoViewController.h"

@interface RBBaseTableViewController () {
    BOOL _isNeedDownRefresh;//是否需要下拉刷新
    BOOL _isNeedUpRefresh;//是否需要上拉刷新
    BOOL _isUpRefresh;//是否正在上拉刷新
    
    UIButton *_titleBtn; //创建导航条的头部视图 标题按钮
    NSInteger _popViewSelectRow; // 第三方库判断选中的行
}

@end

@implementation RBBaseTableViewController

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
    
    [self createUI];
    _manager = [RBDBManager defalutDBManager];
    [_manager createContentJokes];
    [_manager createImageJokes];
    [_manager createImageJokesFindDetail];
    [_manager createBackUpSQLTable];
}

#pragma mark - 创建UI 

#pragma mark 创建tabelView 初始化数据源 --- 公开接口
- (void)createUI {
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    self.view.backgroundColor = RGB(234, 234, 234);
    self.edgesForExtendedLayout = UIRectEdgeNone;//视图控制器，四条边不指定
    self.dataSources = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height-64-49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB(234, 234, 234);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
    // 添加约束
//    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *constraintLeading = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//    NSLayoutConstraint *constraintTrailing = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
//    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-64];
//    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-49];
//    [self.view addConstraints:@[constraintLeading, constraintTrailing, constraintTop, constraintBottom]];

#pragma mark 导航条上的按钮设置
#pragma mark 设置是否需要导航上的按钮 --- 公开接口
// 设置是否需要导航上的按钮
- (void)setNavBarButton:(BOOL)isNeed {
    if (isNeed) {
        [self createNavBarItem];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.titleView = nil;
    }
}

#pragma mark 创建导航条上的按钮 --- 公开接口
- (void)createNavBarItem {
    // 继承父类 用户头像按钮
   [super createNavBarItem];
    
    // 创建导航上的投稿按钮 右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setImage:[UIImage imageNamed:@"submission.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *rightSpaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSpaceBtn.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithCustomView:rightSpaceBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem, rightSpaceItem];
    
    //创建导航条的头部视图 标题按钮
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.frame = CGRectMake(0, 0, 70, 40);
    [_titleBtn setTitle:@"推 荐" forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"downarrow_titlebar.png"] forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"uparrow_titlebar.png"] forState:UIControlStateSelected];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    // 调整图片和文字的位置
    _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 52, 0, 0);
    [_titleBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleBtn;
}

#pragma mark 创建刷新按钮
//如果有刷新功能才创建刷新按钮
- (void)createRefreshBtn {
    //刷新按钮
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn.frame = CGRectMake(WINDOW_SIZE.width-60,WINDOW_SIZE.height-64-49-60, 40, 40);
    _refreshBtn.backgroundColor = [UIColor whiteColor];
    _refreshBtn.layer.cornerRadius = 20;
    _refreshBtn.layer.borderWidth = 1;
    _refreshBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(clickRefreshBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refreshBtn];
}


#pragma mark - 点击事件

#pragma mark 点击进入用户详情页 --- 公开接口
//父类中实现 子类就不用再写了 点击进入用户详情页
- (void)pushToUserInfoVC:(UIButton *)btn {
    RBUserInfoViewController *userInfoVC = [[RBUserInfoViewController alloc] init];
    userInfoVC.userId = [NSString stringWithFormat:@"%ld", (long)btn.tag];
    userInfoVC.title = btn.currentTitle;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - 导航条的头部视图的点击事件
- (void)titleButtonClick:(UIButton *)button {
    button.selected = YES; // 设置选中的图片
    
    CGPoint point = CGPointMake(button.frame.origin.x+button.frame.size.width/2, button.frame.origin.y+button.frame.size.height+8);
    NSArray *titleArray = @[@"推荐", @"精华", @"热门", @"新鲜"];
    NSArray *imageArray = @[@"recomicon_dock.png", @"essenceicon_dock.png", @"hoticon_dock.png", @"newicon_dock.png"];
    NSArray *selectImageArray = @[@"recomicon_dock_press.png", @"essenceicon_dock_press.png", @"hoticon_dock_press.png", @"newicon_dock_press.png"];
    
    // 第三方的库
    PopoverView *popView = [[PopoverView alloc] initWithPoint:point titles:titleArray normolImages:imageArray andSelectImages:selectImageArray];
    // 设置按钮选中的状态
    popView.titleButton = button;
    // 设置默认选中的按钮是第一行的button
    popView.selectedRow = _popViewSelectRow;
    
    // popView的btn的回调
    popView.clickButton = ^(UIButton *btn, NSArray *array) {
        
        // 选中popView上的按钮后导航的头视图显示的是你点击的文字
        [_titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
        
        for (UIButton *tmpBtn in array) {
            tmpBtn.selected = NO;
        }
        btn.selected = YES;
        // 设置导航上的titleView的button为非选中状态
        button.selected = NO;
        
        // 将点击的button的tag值传到popView 设置点击的button为选中状态
        _popViewSelectRow = btn.tag;
        
        // 推荐 精华 热门 新鲜的标识
        self.level = [NSString stringWithFormat:@"%ld", 6 - btn.tag];
        
        [self setUrl];
        [self startRequest];
        
    };
    
    // 显示popView
    [popView show];
}

#pragma mark - 刷新按钮点击事件
- (void)clickRefreshBtn:(UIButton *)btn {
    [UIView animateWithDuration:1.5 animations:^{
        btn.imageView.transform = CGAffineTransformIdentity;
        btn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    
    // 表格执行下拉刷新
    [self.tableView headerBeginRefreshing];
    
    // 动画
    //    CAAnimation *animation = [self animationRotate];
    //    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    //    animationGroup.delegate = self;
    //    animationGroup.removedOnCompletion = NO;
    //
    //    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //    animationGroup.duration = 1;
    //    animationGroup.repeatCount = 1;
    //    animationGroup.fillMode = kCAFillModeForwards;
    //    animationGroup.animations = @[animation];
    //    [btn.layer addAnimation:animationGroup forKey:@"animationRotate"];
}

//刷新按钮动画 未用
- (CAAnimation *)animationRotate {
    CATransform3D transForm = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    basicAnimation.toValue = [NSValue valueWithCATransform3D:transForm];
    basicAnimation.duration = 1;
    basicAnimation.cumulative = YES;
    basicAnimation.beginTime = 0.1;
    basicAnimation.delegate = self;
    
    return basicAnimation;
}

#pragma mark - 刷新

#pragma mark 开始刷新
#pragma mark 刷新前设置网址设置url
- (void)setUrl {
    NSTimeInterval min_time = [[NSDate date] timeIntervalSince1970];
    self.url = [NSString stringWithFormat:TitleView_PATH, _category_id, _level, (int)min_time, TitleView_PATH_PART];
}

#pragma mark 首次刚进入页面设置是否开始刷新 --- 公开接口
- (void)setBeginRefresh:(BOOL)isBegin {
    if (isBegin) {
        [self.tableView headerBeginRefreshing];
    }
}

#pragma mark 设置是否需要下拉刷新和上拉 如果需要就可以刷新
#pragma mark 设置是否需要下拉刷新 --- 公开接口
- (void)setDownRefresh:(BOOL)isNeedDownRefresh {
    _isNeedDownRefresh = isNeedDownRefresh;
    if (isNeedDownRefresh) {
        [self starDownRefresh];
    } else {
        [self.tableView removeHeader];
    }
}

#pragma mark 设置是否需要上拉刷新 --- 公开接口
- (void)setUpRefresh:(BOOL)isNeedUpRefresh {
    _isNeedUpRefresh = isNeedUpRefresh;
    if (isNeedUpRefresh) {
        [self createRefreshBtn];
        [self startUpRefresh];
    } else {
        [self.tableView removeFooter];
        _refreshBtn.hidden = YES;
    }
}

#pragma mark 添加刷新视图回调
//开始下拉刷新
- (void)starDownRefresh {
    //解决强引用的时self
    __block typeof(self)mySelf = self;
    [mySelf.tableView addHeaderWithCallback:^{
        if (_isDownRefresh) {
            return ;
        }
        _isDownRefresh = YES;
        _isDown = YES;
        [self setUrl];
        [self startRequest];
    }];
}

//开始上拉刷新
- (void)startUpRefresh {
    __weak RBBaseTableViewController *baseVC = self;
    [baseVC.tableView addFooterWithCallback:^{
        if (_isUpRefresh) {
            return ;
        }
        _isUpRefresh = YES;
        _isDown = NO;
        [self setUrl];
        [self startRequest];
    }];
}

#pragma mark - 结束刷新 数据请求结束调用

#pragma mark 结束刷新 数据请求结束调用 --- 公开接口
- (void)endRefresh {
    if (_isNeedDownRefresh) {
        [self endDownRefresh];
    }
    if (_isNeedUpRefresh) {
        [self endUpRefresh];
    }
}

//结束下拉刷新
- (void)endDownRefresh {
    _isDownRefresh = NO;
    [self.tableView headerEndRefreshing];
}

//结束上拉刷新
- (void)endUpRefresh {
    _isUpRefresh = NO;
    [self.tableView footerEndRefreshing];
}

#pragma mark - 解析网络请求下来的数据

#pragma mark 开始解析
- (void)startRequest {
    [RBMyConnection connectionWithUrl:_url andFinishBlock:^(NSData *data) {
        [self endRequestWithData:data];
    } andFailedBlock:^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据请求失败,请检查网络连接!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        // 下方出现一个提示label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, WINDOW_SIZE.height, WINDOW_SIZE.width-100, WINDOW_SIZE.height)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;
        label.backgroundColor = [UIColor darkGrayColor];
        label.tag = 1;
        label.text = @"没有网络呦!请检查网络连接!";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:label];
        
        [UIView animateWithDuration:1 animations:^{
            label.alpha = 0.8;
            // 导航条下坐标点为0,0
            label.frame = CGRectMake(50, WINDOW_SIZE.height-40-49-64-20, WINDOW_SIZE.width-100, 30);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(labelRemoveFromSuperView) withObject:nil afterDelay:1];
        }];
        
        // 如果请求失败了 也让其结束刷新功能
        [self endRefresh];
    }];
}

- (void)labelRemoveFromSuperView {
    UILabel *label = (UILabel *)[self.view viewWithTag:1];
    label.alpha = 0;
    [label removeFromSuperview];
}

#pragma mark 网络请求数据结束 --- 公开接口
- (void)endRequestWithData:(NSData *)data {
    [self.tableView reloadData];
    [self endRefresh];
}

#pragma mark - 数据请求结束后 将解析的数据封装成模型类添加到数据源

#pragma mark 向数组中添加数据 --- 公开接口
- (void)dataSourcesAddModel:(id)obj {
    if (_isDown) {
        [self insertObj:obj andIndex:0];
        //控制下拉刷新的个数
        if (self.dataSources.count >= 20) {
            [self.dataSources removeLastObject];
        }
    } else {
        [self addObj:obj];
    }
}

//向数组中插入数据
- (void)insertObj:(id)obj andIndex:(NSInteger)index {
    [self.dataSources insertObject:obj atIndex:index];
}

//向数组中按顺序插入添加数据
- (void)addObj:(id)obj {
    [self.dataSources addObject:obj];
}

#pragma mark - 表格视图协议中的方法

#pragma mark 设置表格分区中显示行数(默认是1个分区)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSources.count;
}

#pragma mark 设置表格中单元格的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

@end
