//
//  RBLatestModel.h
//  Content Jokes
//
//  Created by qianfeng on 15-3-1.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBLatestModel : NSObject

// 模型的另一部分用contenModel 往期也用这个数据模型

@property(nonatomic, copy) NSString *activity_name; // 发起人名字
@property(nonatomic, copy) NSString *url; // 图片
@property(nonatomic, copy) NSString *title; // 标题
@property(nonatomic, strong) NSNumber *start_time; // 开始时间
@property(nonatomic, strong) NSNumber *end_time; // 结束时间
@property(nonatomic, copy) NSString *text; // 文本内容
@property(nonatomic, strong) NSNumber *group_count; // 内容个数
@property(nonatomic, strong) NSNumber *user_count;// 用户参加个数

@property(nonatomic, strong) NSNumber *categoryId; // 往期网址需要这个id(网址数据实际为id)

@end
