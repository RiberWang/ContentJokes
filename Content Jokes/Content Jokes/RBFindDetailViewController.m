//
//  RBFindDetailViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-5.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBFindDetailViewController.h"
#import "RBImageModel.h"
#import "RBFindModel.h"
#import "RBFindDetailTableViewHeaderView.h"
#import "RBFindDetailSecond.h"

@interface RBFindDetailViewController ()

@end

@implementation RBFindDetailViewController

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
    
    [self setDownRefresh:YES];
    [self setNavBarButton:NO];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 44);
    [btn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self setUrl];
    [self startRequest];
}

- (void)leftBackButton:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUrl {
    int min_time = [[NSDate date] timeIntervalSince1970];
    self.url = [NSString stringWithFormat:FIND_PATH_DETAIL, _findModel.categoryId, FIND_PATH_DETAIL_PART1, min_time, FIND_PATH_DETAIL_PART2];
}

#pragma mark - 修改刷新按钮的位置 这个页面的tabBar隐藏了
- (void)createRefreshBtn {
    [super createRefreshBtn];
    self.refreshBtn.frame = CGRectMake(WINDOW_SIZE.width-60,WINDOW_SIZE.height-64-60, 40, 40);
}

- (void)createUI {
    self.dataSources = [[NSMutableArray alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height - 64) style:UITableViewStylePlain]; // grouped样式的表格的尾部会出现一片空白 解决办法:设置表格的高度时 在算好的高度上+36(大概的数值) 下面有刷新的视图 这样设置不行
    self.tableView.backgroundColor = RGB(234, 234, 234);
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

// 解决 frame 问题 不悬浮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 80; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y >= sectionHeaderHeight)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//重写父类中的方法
- (void)endRequestWithData:(NSData *)data {
    [self.dataSources removeAllObjects];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *firstDataDic = dic[@"data"];
    for (NSDictionary *secondDataDic in firstDataDic[@"data"]) {
        NSDictionary *groupDic = secondDataDic[@"group"];
        if (groupDic) {
            RBImageModel *imageModel = [[RBImageModel alloc] init];
            [imageModel setValuesForKeysWithDictionary:groupDic];
            NSDictionary *userDic = groupDic[@"user"];
            [imageModel setValuesForKeysWithDictionary:userDic];
            
            //小图片赋值
            NSDictionary *middle_imageDic = groupDic[@"middle_image"];
            [imageModel setValuesForKeysWithDictionary:middle_imageDic];
            NSArray *url_listArray = middle_imageDic[@"url_list"];
            imageModel.url = url_listArray[0][@"url"];
            
            //大图片赋值
            NSDictionary *large_imageDic = groupDic[@"large_image"];
            imageModel.largeWidth = large_imageDic[@"width"];
            imageModel.largeHeight = large_imageDic[@"height"];
            NSArray *largeUrl_listArray = large_imageDic[@"url_list"];
            imageModel.largeUrl = largeUrl_listArray[0][@"url"];
            
            [self dataSourcesAddModel:imageModel];
        }
    }
    
    [super endRequestWithData:data];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RBFindDetailTableViewHeaderView *headerView = [RBFindDetailTableViewHeaderView findDetailTableViewHeaderView];
    
    // 填充数据
    [headerView.iconImgView setImageWithURL:[NSURL URLWithString:_findModel.icon]];
    headerView.nameLabel.text = _findModel.name;
    headerView.placeholderLabel.text = _findModel.placeholder;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"CONTENT"];
    if (contentCell == nil) {
        contentCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBContentCell class]) owner:self options:nil] lastObject];
    }
    
    RBImageModel *imageModel = self.dataSources[indexPath.row];
    
    [contentCell.avatarImage setImageWithURL:[NSURL URLWithString:imageModel.avatar_url] placeholderImage:[UIImage imageNamed:@"defaulthead.png"]];
    contentCell.nameLabel.text = imageModel.name;
    
    // 逻辑判断
    if (imageModel.content.length == 0 && imageModel.url != nil)
    {
        contentCell.contentLabel.hidden = YES;
        contentCell.contentLabel.hidden = NO;
        
        [contentCell.contentView addSubview:contentCell.contentImage];
        [contentCell.contentImage setImageWithURL:[NSURL URLWithString:imageModel.url]];
    }
    else if (imageModel.content.length != 0 && imageModel.url != nil)
    {
        contentCell.contentLabel.hidden = NO;
        contentCell.contentImage.hidden = NO;
        
        [contentCell.contentView addSubview:contentCell.contentImage];
        contentCell.contentLabel.text = imageModel.content;
        [contentCell.contentImage setImageWithURL:[NSURL URLWithString:imageModel.url]];
    }
    else if (imageModel.content.length != 0 && imageModel.url == nil)
    {
        contentCell.contentLabel.hidden = NO;
        contentCell.contentImage.hidden = YES;
        
        [contentCell.contentImage removeFromSuperview];
        
        contentCell.contentLabel.text = imageModel.content;
    }
    else
    {
        contentCell.contentLabel.hidden = YES;
        contentCell.contentImage.hidden = YES;
    }
    
    contentCell.diggCountLabel.text = [NSString stringWithFormat:@"%@", imageModel.digg_count];
    contentCell.buryCountLabel.text = [NSString stringWithFormat:@"%@", imageModel.bury_count];
    contentCell.commentCountLabel.text = [NSString stringWithFormat:@"%@", imageModel.comment_count];
    
    // 图片最高的不超过600
    CGFloat height = [imageModel.height  floatValue];
//    if (height >= 600) {
//        height = 600;
//    }
    
    //contentLabel 20 50 280 30
    if (imageModel.content.length == 0 && imageModel.url != nil)
    {
        contentCell.contentImage.frame = CGRectMake(contentCell.contentLabel.frame.origin.x, contentCell.contentLabel.frame.origin.y, [imageModel.width floatValue], height);
    }
    else if (imageModel.content.length != 0 && imageModel.url != nil)
    {
        //动态设置评论内容的大小
        CGRect frame = contentCell.contentLabel.frame;
        frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height);
        contentCell.contentLabel.frame = frame;
        
        // contentImage
        contentCell.contentImage.frame = CGRectMake(contentCell.contentImage.frame.origin.x, contentCell.contentLabel.frame.origin.y+contentCell.contentLabel.frame.size.height+10, [imageModel.width floatValue], height);
    }
    else if (imageModel.content.length == 0 && imageModel.url == nil)
    {
    }
    else if (imageModel.content.length != 0 && imageModel.url == nil)
    {
        //动态设置评论内容的大小
        CGRect frame = contentCell.contentLabel.frame;
        frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height);
        contentCell.contentLabel.frame = frame;
    }

    //设置button的长度
    CGRect rect = [RBMixed setButtonFrameWithLabelText:imageModel.name andLabelWidth:240 andLabelFontSize:17];
    contentCell.userInfoButton.frame = CGRectMake(contentCell.userInfoButton.frame.origin.x, contentCell.userInfoButton.frame.origin.y, rect.size.width, contentCell.userInfoButton.frame.size.height);
    
    //为button添加事件
    [contentCell.userInfoButton addTarget:self action:@selector(pushToUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
    contentCell.userInfoButton.tag = [imageModel.user_id intValue];
    [contentCell.userInfoButton setTitle:imageModel.name forState:UIControlStateNormal];
    
    //设置不可点击的button的frame
    contentCell.nonClickButton.frame = CGRectMake(contentCell.userInfoButton.frame.origin.x+contentCell.userInfoButton.frame.size.width, 0, 300-contentCell.userInfoButton.frame.size.width, 50);
    
    return contentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }
    return 0;
}

//动态设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBImageModel *imageModel = self.dataSources[indexPath.row];
    
    CGFloat height = [imageModel.height  floatValue];
//    if (height >= 600) {
//        height = 600;
//    }
    
    if (imageModel.content.length == 0 && imageModel.url != nil)
    {
        return 20+15+5*10+height;
    }
    else if (imageModel.content.length != 0 && imageModel.url != nil)
    {
        //如果有评论内容
        return ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height)+20+15+6*10+height; // 6个间隔 下面还有10的间隔
    }
    else if (imageModel.content.length == 0 && imageModel.url == nil)
    {
    }
    else if (imageModel.content.length != 0 && imageModel.url == nil)
    {
       return ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height)+20+15+5*10;
    }
    
    return 0;
}

//点击进入详情页 有评论
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBImageModel *imageModel = self.dataSources[indexPath.row];
    RBFindDetailSecond *imageDetailVC = [[RBFindDetailSecond alloc] init];
    imageDetailVC.imageModel = imageModel;
    if (imageModel.content.length != 0) {
        imageDetailVC.textLabelHeight = ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height);
    }
    
    [self.navigationController pushViewController:imageDetailVC animated:YES];
}

@end
