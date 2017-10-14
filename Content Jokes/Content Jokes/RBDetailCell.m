//
//  RBDetailCell.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-25.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBDetailCell.h"
#import "RBDetailModel.h"
#import "RBDetailTopComModel.h"
#import "RBCommentModel.h"

@implementation RBDetailCell

- (void)awakeFromNib
{
    // Initialization code
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 显示详情页中的内容
- (void)showInDetailCell:(RBDetailModel *)detailModel {
    [self.headImage setImageWithURL:[NSURL URLWithString:detailModel.user_profile_image_url]];
    self.nameLabel.text = detailModel.user_name;
    self.digCountLabel.text = [NSString stringWithFormat:@"%@",detailModel.digg_count];
    self.commentLabel.text = detailModel.text;
    self.timeLabel.text = [self calculateTime:detailModel.create_time];
}

- (void)showInDetailTopCell:(RBDetailTopComModel *)topModel {
    [self.headImage setImageWithURL:[NSURL URLWithString:topModel.user_profile_image_url]];
    self.nameLabel.text = topModel.user_name;
    self.digCountLabel.text = [NSString stringWithFormat:@"%@",topModel.digg_count];
    self.commentLabel.text = topModel.text;
    self.timeLabel.text = [self calculateTime:topModel.create_time];
}

- (NSString *)calculateTime:(NSNumber *)time {
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //将double类型的日期转换为时间类型的对象
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time doubleValue]];
    
    return [fm stringFromDate:date];
}

#pragma mark - 显示用户详情页中的评论页中的内容
- (void)showInDetailCellOfUserInfoComment:(RBCommentModel *)commentModel {
    // 设置隐藏的显示(label) 显示的隐藏
    self.contentLabel.hidden = NO; // 填充content的label设置显示
    self.respodeButton.hidden = NO; // 回复按钮设置显示
    self.digCountLabel.hidden = YES; // 设置顶的个数标签隐藏
    self.digButton.hidden = YES; // 设置顶的按钮隐藏
    
    [self.headImage setImageWithURL:[NSURL URLWithString:commentModel.avatar_url]];
    self.nameLabel.text = commentModel.user_screen_name;
    self.digCountLabel.text = [NSString stringWithFormat:@"%@",commentModel.digg_count];
    self.timeLabel.text = [self calculateTime:commentModel.create_time];
    self.commentLabel.text = commentModel.text;
    self.contentLabel.text = commentModel.content;
}

- (void)showInGodCommentDetailCell:(RBCommentModel *)commentModel {
    self.contentLabel.hidden = NO; // 填充content的label设置显示
    self.categoryNameLabel.hidden = NO; // 平台
    self.respodeButton.hidden = YES; // 回复按钮设置显示
    self.digCountLabel.hidden = NO; // 设置顶的个数标签隐藏
    self.digButton.hidden = NO; // 设置顶的按钮隐藏
    
    [self.headImage setImageWithURL:[NSURL URLWithString:commentModel.user_profile_image_url]];
    self.nameLabel.text = commentModel.user_name;
    self.digCountLabel.text = [NSString stringWithFormat:@"%@",commentModel.digg_count];
    self.timeLabel.text = [self calculateTime:commentModel.create_time];
    self.commentLabel.text = commentModel.text;
    self.contentLabel.text = commentModel.content;
    self.categoryNameLabel.text = [NSString stringWithFormat:@"来自:%@", commentModel.category_name];
}


@end
