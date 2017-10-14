//
//  RBFindModel.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-30.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBFindModel : NSObject <NSCoding>

// 1.表格头部视图数据
@property(nonatomic, copy) NSString *title;//第一届八卦掌门争夺赛开始啦
@property(nonatomic, copy) NSString *url;//图片网址
@property(nonatomic, strong) NSNumber *height;
@property(nonatomic, strong) NSNumber *width;

// 2.神评论数据 未用...
@property(nonatomic, strong) NSNumber *count;//个数
@property(nonatomic, copy) NSString *intro;//简介
@property(nonatomic, copy) NSString *godName;//神评论
@property(nonatomic, copy) NSString *godIcon;//图标

// 3.下面内容数据
@property(nonatomic, copy) NSString *placeholder;//下面介绍
@property(nonatomic, copy) NSString *icon;//图标
@property(nonatomic, copy) NSString *name; // 名称
@property(nonatomic, strong) NSNumber *categoryId; // 网址根据这个变化

@end
