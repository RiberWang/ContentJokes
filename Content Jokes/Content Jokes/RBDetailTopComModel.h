//
//  RBDetailTopComModel.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-31.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBDetailTopComModel : NSObject

@property(nonatomic, copy) NSString *user_name;//评论的用户名
@property(nonatomic, strong) NSNumber *user_id; // 用户id
@property(nonatomic, copy) NSString *text;//评论内容
@property(nonatomic, copy) NSString *user_profile_image_url;//用户头像
@property(nonatomic, strong) NSNumber *digg_count;//顶的个数
@property(nonatomic, strong) NSNumber *create_time;//时间
@property(nonatomic, strong) NSNumber *total_number;//评论总的个数

@end
