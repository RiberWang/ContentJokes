//
//  RBUGCDetailVC.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-4.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBUGCSuperVC.h"
#import "RBImageModel.h"
#import "RBContentCell.h"
#import "RBImageDetailViewController.h"

@interface RBUGCSuperVC ()

@end

@implementation RBUGCSuperVC

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
    [self setUpRefresh:YES];
    [self setNavBarButton:YES];
    [self setBeginRefresh:YES];
}

- (void)setUrl {
    NSTimeInterval min_time = [[NSDate date] timeIntervalSince1970];
    self.url = [NSString stringWithFormat:IMAGE_PATH, (int)min_time, IMAGE_PATH_PART];
}

//重写父类中的方法
- (void)endRequestWithData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *firstDataDic = dic[@"data"];
    for (NSDictionary *secondDataDic in firstDataDic[@"data"]) {
        NSDictionary *groupDic = secondDataDic[@"group"];
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
        
        UIImage *avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userDic[@"avatar_url"]]]];
        imageModel.avatarImage = avatarImage;
        
        // 小图片
        UIImage *contentImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_listArray[0][@"url"]]]];
        imageModel.contentImage = contentImage;
        
        // 大图片
        UIImage *contentLargeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:largeUrl_listArray[0][@"url"]]]];
        imageModel.contentLargeImage = contentLargeImage;

        [self dataSourcesAddModel:imageModel];
    }
    
    [super endRequestWithData:data];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"CONTENT"];
    if (contentCell == nil) {
        contentCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBContentCell class]) owner:self options:nil] lastObject];
    }
    
    RBImageModel *imageModel = self.dataSources[indexPath.row];
    
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
    
    contentCell.netIsConnect = self.netIsAvaild;
    [contentCell showInImageCell:imageModel];
    
    if (imageModel.content.length == 0 && imageModel.url != nil)
    {
        contentCell.contentImage.frame = CGRectMake(contentCell.contentLabel.frame.origin.x, contentCell.contentLabel.frame.origin.y, [imageModel.width floatValue], [imageModel.height floatValue]);
    }
    else if (imageModel.content.length != 0 && imageModel.url != nil)
    {
        //动态设置评论内容的大小
        CGRect frame = contentCell.contentLabel.frame;
        frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height);
        contentCell.contentLabel.frame = frame;
        
        // contentImage
        contentCell.contentImage.frame = CGRectMake(contentCell.contentImage.frame.origin.x, contentCell.contentLabel.frame.origin.y+contentCell.contentLabel.frame.size.height+10, [imageModel.width floatValue], [imageModel.height floatValue]);
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

#pragma mark - 进入用户详情页 父类中实现

//动态设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBImageModel *imageModel = self.dataSources[indexPath.row];
    if (imageModel.content.length == 0) {
        return 20+15+5*10+[imageModel.height floatValue];
    }
    if (imageModel.url == nil) {
        return ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height)+20+15+5*10; // 4个间隔 下面还有10的间隔
    }
    //如果有评论内容
    return ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height)+20+15+6*10+[imageModel.height floatValue]; // 5个间隔 下面还有10的间隔
}

//点击进入详情页 有评论
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBImageModel *imageModel = self.dataSources[indexPath.row];
    RBImageDetailViewController *imageDetailVC = [[RBImageDetailViewController alloc] init];
    imageDetailVC.imageModel = imageModel;
    imageDetailVC.textLabelHeight = ceil([RBMixed setLabelFrameAccordingTextContent:imageModel.content andLabelWidth:280 andLabelFontSize:15].height);
    [self.navigationController pushViewController:imageDetailVC animated:YES];
}

@end
