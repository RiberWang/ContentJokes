//
//  RBCommentModel.h
//  Content Jokes
//
//  Created by qianfeng on 15-3-3.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBCommentModel : NSObject

// 用户信息
@property(nonatomic, copy) NSString *avatar_url; // 头像网址
@property(nonatomic, copy) NSString *user_screen_name; // 用户名
@property(nonatomic, copy) NSString *user_id; // 用户id
@property(nonatomic, strong) NSNumber *group_id; // 点击段子的id
@property(nonatomic, copy) NSString *text; // 评论内容
@property(nonatomic, copy) NSString *content; // 发表内容
@property(nonatomic, copy) NSString *comment_id; // 评论的id
@property(nonatomic, strong) NSNumber *create_time;//时间

@property(nonatomic, strong) NSNumber *digg_count; // 顶的个数
@property(nonatomic, strong) NSNumber *bury_count; // 踩的个数
@property(nonatomic, strong) NSNumber *comment_count; // 评论个数

// 神评论模型添加的内容
@property(nonatomic, copy) NSString *user_name; // 用户名
@property(nonatomic, copy) NSString *category_name; // 发布评论的平台
@property(nonatomic, copy) NSString *user_profile_image_url; // 评论用户的头像
@end
