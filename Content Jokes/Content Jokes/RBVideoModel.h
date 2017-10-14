//
//  RBVideoModel.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-26.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBVideoModel : NSObject

@property(nonatomic, copy) NSString *avatar_url;//头像
@property(nonatomic, copy) NSString *name;//名称
@property(nonatomic, copy) NSString *user_id;//用户id
@property(nonatomic, strong) NSNumber *group_id;//点击段子的id
@property(nonatomic, copy) NSString *content;//发表内容
@property(nonatomic, strong) NSNumber *digg_count;//顶的个数
@property(nonatomic, strong) NSNumber *bury_count;//踩的个数
@property(nonatomic, strong) NSNumber *comment_count;//评论个数

@property(nonatomic, copy) NSString *mp4_url;//视频播放网址
@property(nonatomic, strong) NSNumber *duration;//视频的时间
@property(nonatomic, copy) NSString *play_count;//播放次数
@property(nonatomic, strong) NSNumber *video_height;//视频的高
@property(nonatomic, strong) NSNumber *video_width;//视频的宽

//未用
@property(nonatomic, strong) NSNumber *has_hot_comments;//热门评论

@end
