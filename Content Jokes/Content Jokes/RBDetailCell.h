//
//  RBDetailCell.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-25.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "RBJokeCell.h"

@class RBDetailModel;
@class RBDetailTopComModel;
@class RBCommentModel;

@interface RBDetailCell : RBJokeCell

// 详细页和用户 评论页 的cell
@property(nonatomic, strong) IBOutlet UIImageView *headImage;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;
@property(nonatomic, strong) IBOutlet UILabel *contentLabel; // text评论内容
@property(nonatomic, strong) IBOutlet UILabel *digCountLabel; // 顶的个数

@property(nonatomic, strong) IBOutlet UILabel *commentLabel; // comment 被评论的内容

@property(nonatomic, strong) IBOutlet UIButton *digButton; // 顶的图片按钮
@property(nonatomic, strong) IBOutlet UIButton *respodeButton; // 回复按钮
@property(nonatomic, strong) IBOutlet UIButton *userInfoButton; // 用户详情
@property (nonatomic, strong) IBOutlet UILabel *categoryNameLabel; // 来自平台

// 显示详情页中的内容
// 显示新鲜评论
- (void)showInDetailCell:(RBDetailModel *)detailModel;
// 显示热门评论
- (void)showInDetailTopCell:(RBDetailTopComModel *)topModel;

- (void)showInDetailCellOfUserInfoComment:(RBCommentModel *)commentModel;

// 显示神评论
- (void)showInGodCommentDetailCell:(RBCommentModel *)commentModel;

@end
