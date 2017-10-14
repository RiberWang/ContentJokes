//
//  RBFindDetailSecond.m
//  Content Jokes
//
//  Created by riber on 15/12/15.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBFindDetailSecond.h"

@interface RBFindDetailSecond ()

@end

@implementation RBFindDetailSecond

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailCell *detailCell = (RBDetailCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        RBContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"CONTENT"];
        if (contentCell == nil) {
            contentCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBContentCell class]) owner:self options:nil] lastObject];
        }
        
        RBImageModel *imageModel = self.imageModel;
        [contentCell.avatarImage setImageWithURL:[NSURL URLWithString:imageModel.avatar_url] placeholderImage:[UIImage imageNamed:@"defaulthead.png"]];
        contentCell.nameLabel.text = imageModel.name;


        //显示第一个分区cell的信息
        // 逻辑判断
        if (imageModel.content.length == 0 && imageModel.url != nil)
        {
            contentCell.contentLabel.hidden = YES;
            contentCell.contentImage.hidden = NO;
            
            [contentCell.contentImage setImageWithURL:[NSURL URLWithString:imageModel.url]];
        }
        else if (imageModel.content.length != 0 && imageModel.url != nil)
        {
            contentCell.contentLabel.hidden = NO;
            contentCell.contentImage.hidden = NO;
            
            contentCell.contentLabel.text = imageModel.content;
            [contentCell.contentImage setImageWithURL:[NSURL URLWithString:imageModel.url]];
        }
        else if (imageModel.content.length != 0 && imageModel.url == nil)
        {
            contentCell.contentLabel.hidden = NO;
            contentCell.contentImage.hidden = YES;
            
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
//        if (height >= 600) {
//            height = 600;
//        }
        
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
        
        //给图片添加手势
        [self addGesture:contentCell.contentImage];
        
        // 用户信息页
        // 点击进入用户详情页
        contentCell.userInfoButton.tag = [self.imageModel.user_id intValue];
        [contentCell.userInfoButton setTitle:self.imageModel.name forState:UIControlStateNormal];
        [contentCell.userInfoButton addTarget:self action:@selector(gotoUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
        
        return contentCell;
    }
    
    return detailCell;
}


#pragma mark - 小图片添加手势 使其点击进入大图
//给点击的小图图片添加手势 在cell里调用
- (void)addGesture:(UIImageView *)imgView {
    [super addGesture:imgView];
}


@end
