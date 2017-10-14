//
//  RBContentModel.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-24.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBContentModel : NSObject

@property(nonatomic, copy) NSString *avatar_url;//头像
@property(nonatomic, copy) NSString *name;//名称
@property(nonatomic, strong) NSNumber *user_id;//用户id
@property(nonatomic, strong) NSNumber *group_id;//点击段子的id
@property(nonatomic, copy) NSString *content;//发表内容
@property(nonatomic, strong) NSNumber *digg_count;//顶的个数
@property(nonatomic, strong) NSNumber *bury_count;//踩的个数
@property(nonatomic, strong) NSNumber *comment_count;//评论个数
@property(nonatomic, strong) NSNumber *status;//状态(穿越 热门 一般)//不确定
@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, copy) NSString *title; // 广告 cell

@end
