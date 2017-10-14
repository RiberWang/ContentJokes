//
//  RBUserInfoModel.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-28.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBUserInfoModel : NSObject

@property(nonatomic, copy) NSString *avatar_url;//头像网址
@property(nonatomic, copy) NSString *name;//名字
@property(nonatomic, copy) NSString *user_id;//用户id
@property(nonatomic, copy) NSString *userDescription;//用户描述
@property(nonatomic, strong) NSNumber *point;//积分
@property(nonatomic, strong) NSNumber *gender;//举报
@property(nonatomic, strong) NSNumber *followings;//关注左边
@property(nonatomic, strong) NSNumber *followers;//粉丝右边
@property(nonatomic, strong) NSNumber *comment_count;//评论
@property(nonatomic, strong) NSNumber *ugc_count;//投稿
@property(nonatomic, strong) NSNumber *repin_count;//收藏


@end
