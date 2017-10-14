//
//  RBFindViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBFindViewController.h"
#import "RBFindModel.h"
#import "RBFindCell.h"
#import "RBLatestViewController.h"
#import "RBGodCommentViewController.h"
#import "RBFindDetailViewController.h"

@interface RBFindViewController () <UIScrollViewDelegate> {
    NSArray *_bannersArray;// 表格的头滚动视图
    NSMutableDictionary *_godDic;// 神评论
    
    UIScrollView *_scrollView;//滚动视图
    UIPageControl *_pageControl;// 分页控件
    UILabel *_label;//显示文字和分页控件
    
    NSTimer *_timer; // 定时器
}

@end

static int page;

@implementation RBFindViewController

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
    
    self.navigationItem.title = @"发现";
    [self setDownRefresh:YES];
    [self setNavBarButton:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *array = [[RBCommonSave defaultCommonSave] readMessageOfArray:YES fromSandBoxWithFileName:@"category_list"];
    NSArray *banerArray = [[RBCommonSave defaultCommonSave] readMessageOfArray:YES fromSandBoxWithFileName:@"banners"];

    NSDictionary *dic = [[RBCommonSave defaultCommonSave] readMessageOfArray:NO fromSandBoxWithFileName:@"godDic"];
    
    if (array && banerArray && dic) {
        self.dataSources = (NSMutableArray *)array;
        _bannersArray = banerArray;
        _godDic = (NSMutableDictionary *)dic;
    }
    else
    {
        [self setUrl];
        [self startRequest];
        [self startRequestGodCommentCount];
    }
}

- (void)createUI {
    self.dataSources = [[NSMutableArray alloc] init];
    _godDic = [[NSMutableDictionary alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height - 64 - 49 + 36) style:UITableViewStyleGrouped]; // grouped样式的表格的尾部会出现一片空白 解决办法:设置表格的高度时 在算好的高度上+36(大概的数值)
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)setUrl {
    self.url = FIND_PATH;
}

//开始下拉刷新
- (void)starDownRefresh {
    __weak typeof(self)mySelf = self;
    
    page = 0;
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    
    [mySelf.tableView addHeaderWithCallback:^{
        if (mySelf.isDownRefresh) {
            return ;
        }
        mySelf.isDownRefresh = YES;
        mySelf.isDown = YES;
        [mySelf setUrl];
        [mySelf startRequest];
        
        [mySelf startRequestGodCommentCount];
        
    }];
}

- (void)endRequestWithData:(NSData *)data {    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *dataDic = dic[@"data"];
    
    NSDictionary *godDic = dataDic[@"god_comment"];
    
    [_godDic setValuesForKeysWithDictionary:godDic];
    
    NSDictionary *rotateDic = dataDic[@"rotate_banner"];
    _bannersArray = rotateDic[@"banners"];
    
    [[RBCommonSave defaultCommonSave] writeMessageOfArray:_bannersArray toSandBoxWithFileName:@"banners"];

    NSDictionary *cateDic = dataDic[@"categories"];

    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *cateListDic in cateDic[@"category_list"]) {
        RBFindModel *findModel = [[RBFindModel alloc] init];
        
        [findModel setValuesForKeysWithDictionary:cateListDic];
        findModel.categoryId = cateListDic[@"id"];
        [array addObject:findModel];
    }
    
    self.dataSources = array;
    [[RBCommonSave defaultCommonSave] writeMessageOfArray:self.dataSources toSandBoxWithFileName:@"category_list"];
    
    [super endRequestWithData:data];
}

- (void)startRequestGodCommentCount {
    int min_time = [[NSDate date] timeIntervalSince1970];
    self.url = [NSString stringWithFormat:FIND_PATH_GOD_COMMENT_COUNT, min_time, FIND_PATH_GOD_COMMENT_COUNT_PART];
    
    [RBMyConnection connectionWithUrl:self.url andFinishBlock:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // 神评论更新数
        NSDictionary *dataDic = dic[@"data"];
        if (dataDic[@"tips"] == nil) {
            [_godDic setValue:@"暂时没有更新" forKey:@"tips"];
        } else {
            [_godDic setValue:dataDic[@"tips"] forKey:@"tips"];
        }
        
        [[RBCommonSave defaultCommonSave] writeMessageOfArray:_godDic toSandBoxWithFileName:@"godDic"];
        
        [self.tableView reloadData];
    } andFailedBlock:^{
        NSLog(@"失败");
    }];
}


#pragma mark - 表格视图的协议中的方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataSources.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBFindCell *findCell = [tableView dequeueReusableCellWithIdentifier:@"FIND"];
    if (findCell == nil) {
        findCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBFindCell class]) owner:self options:nil] lastObject];
    }
    
    if (indexPath.section == 0) {
        [findCell.iconImageView setImageWithURL:[NSURL URLWithString:_godDic[@"icon"]]];
    findCell.nameLabel.text = _godDic[@"name"];
        findCell.placeholderLabel.text = _godDic[@"tips"];
    } else if (indexPath.section == 1){
        RBFindModel *findModel = self.dataSources[indexPath.row];
        // 最后一个网址转码
        NSString *string = findModel.icon;
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [findCell.iconImageView setImageWithURL:[NSURL URLWithString:string]];
        //http://s0.pstatp.com/site/image/joke_zone/fankui_slogan%20640.pic.jpg
        //http://s0.pstatp.com/site/image/joke_zone/fankui_slogan 640.pic.jpg

        findCell.nameLabel.text = findModel.name;
        findCell.placeholderLabel.text = findModel.placeholder;
   }
    
    return findCell;
}

#pragma mark - 表格视图的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 第0个分区的点击事件 神评论
    if (indexPath.section == 0) {
        RBGodCommentViewController *godCommentVC = [[RBGodCommentViewController alloc] init];
        godCommentVC.title = @"神评论";
        [self.navigationController pushViewController:godCommentVC animated:YES];
    } else {
        RBFindDetailViewController *findDetailVC = [[RBFindDetailViewController alloc] init];
        findDetailVC.findModel = self.dataSources[indexPath.row];
        findDetailVC.title = findDetailVC.findModel.name;
        [self.navigationController pushViewController:findDetailVC animated:YES];
    }
}

#pragma mark - 自定义表格分区的头部视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    }
    
    return 0;
}

#pragma mark - 自定义表格分区的头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        // 创建背景view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, 100)];
        _scrollView = [[UIScrollView alloc] initWithFrame:view.bounds];
        _scrollView.contentSize = CGSizeMake(WINDOW_SIZE.width*(_bannersArray.count+2), 100);
        _scrollView.tag = 326;
        _scrollView.contentOffset = CGPointMake(WINDOW_SIZE.width, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [view addSubview:_scrollView];
        
        // 创建label用来显示文字
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100-20, WINDOW_SIZE.width, 20)];
        _label.backgroundColor = [UIColor darkGrayColor];
        _label.alpha = 0.7;
        _label.text = _bannersArray[0][@"banner_url"][@"title"];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:15];
        [view addSubview:_label];
        
        //创建分页控件
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WINDOW_SIZE.width-100, 100-20, 100, 20)];
        _pageControl.numberOfPages = _bannersArray.count;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        [_pageControl addTarget:self action:@selector(pressPageControll) forControlEvents:UIControlEventValueChanged];
        [view addSubview:_pageControl];
        
        if (_bannersArray.count < 2) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WINDOW_SIZE.width, 0, WINDOW_SIZE.width, 100)];
            imgView.tag = 100;
            [_scrollView addSubview:imgView];
            
            // 为图片添加手势
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [imgView addGestureRecognizer:tap];
        }
        
        for (int i = 0; i < _bannersArray.count+2; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WINDOW_SIZE.width*i, 0, WINDOW_SIZE.width, 100)];
            
            if (i == 0) {
                NSDictionary *bannerDic = _bannersArray[_bannersArray.count-1][@"banner_url"];
                [imgView setImageWithURL:[NSURL URLWithString:bannerDic[@"url_list"][0][@"url"]]];
            } else if (i == _bannersArray.count + 1) {
                NSDictionary *bannerDic = _bannersArray[0][@"banner_url"];
                [imgView setImageWithURL:[NSURL URLWithString:bannerDic[@"url_list"][0][@"url"]]];
            } else {
                // 获取banner数组中的字典 添加图片
                NSDictionary *bannerDic = _bannersArray[i-1][@"banner_url"];
                [imgView setImageWithURL:[NSURL URLWithString:bannerDic[@"url_list"][0][@"url"]]];
                imgView.tag = 100+i-1;
            }
            
            [_scrollView addSubview:imgView];
            
            // 为图片添加手势
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [imgView addGestureRecognizer:tap];
            
            if (_bannersArray.count >= 2) {
                 _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(circlePlay) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            }
        }
        
        return view;
    }
    
    return nil;
}

- (void)pressPageControll {
    int page = (int)_pageControl.currentPage;
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake((page+1)*WINDOW_SIZE.width, 0);
    }];
}


// 图片来回滚动
- (void)changePic
{
    static int width;
    width = WINDOW_SIZE.width;
    _pageControl.currentPage = (_scrollView.contentOffset.x+width)/width;
    
    [UIView animateWithDuration:1 animations:^{
        _scrollView.contentOffset = CGPointMake(_pageControl.currentPage * width, 0);
    } completion:nil];
    if (_pageControl.currentPage == _bannersArray.count-1) {
        width = -WINDOW_SIZE.width;
    }
    if (_pageControl.currentPage == 0) {
        width = WINDOW_SIZE.width;
    }
}

// 循环滚动
- (void)circlePlay {
    page++;
    if (page >= _bannersArray.count+1) {
        page = 1;
    }
    
    [_scrollView scrollRectToVisible:CGRectMake(page*WINDOW_SIZE.width, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:YES];
}

#pragma mark - 图片的点击事件
// 现在只有一张图片
- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIImageView *imgView = (UIImageView *)tap.view;
    NSLog(@"imageView.tag:%ld", imgView.tag);
    switch (imgView.tag) {
        case 100:
        {
            RBLatestViewController *latestVC = [[RBLatestViewController alloc] init];
            latestVC.title = @"热门活动";
            [self.navigationController pushViewController:latestVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 表格头部视图的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 326) {
        //循环滚动
        if ((int)scrollView.contentOffset.x % (int)WINDOW_SIZE.width == 0) {
            int currentPage = (int)scrollView.contentOffset.x/WINDOW_SIZE.width;
            _pageControl.currentPage = currentPage-1;
            _label.text = _bannersArray[_pageControl.currentPage][@"banner_url"][@"title"];
            
            if (currentPage == 0) {
                [scrollView setContentOffset:CGPointMake(_bannersArray.count*WINDOW_SIZE.width, 0)];
            }
            if (currentPage == _bannersArray.count+1) {
                [scrollView setContentOffset:CGPointMake(WINDOW_SIZE.width, 0)];
                _label.text = _bannersArray[0][@"banner_url"][@"title"];
            }
        }
        
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    }
}

@end
