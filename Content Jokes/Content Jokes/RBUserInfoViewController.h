//
//  RBUserInfoViewController.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-28.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBBaseViewController.h"

@interface RBUserInfoViewController : RBBaseViewController

@property(nonatomic, copy) NSString *userId;//接收上个页面传来的用户id

@property(nonatomic, strong) IBOutlet UIImageView *headImage;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *followersLabel;//粉丝
@property(nonatomic, strong) IBOutlet UILabel *followingsLabel;//关注
@property(nonatomic, strong) IBOutlet UILabel *pointLabel;//积分
@property(nonatomic, strong) IBOutlet UILabel *desLabel;//描述

@property(nonatomic, strong) IBOutlet UILabel *ugcLabel;//投稿
@property(nonatomic, strong) IBOutlet UILabel *commentLabel;//评论
@property(nonatomic, strong) IBOutlet UILabel *repinLabel;//收藏

@property(nonatomic, strong) IBOutlet UIButton *addBtn;

// 点击进入积分页面 查看常见问题 ---已实现
- (IBAction)gotoQuestion:(id)sender;

- (IBAction)addFollowing:(id)sender;

- (IBAction)sendPrivateLetter:(id)sender;

// ---已实现
// 投稿页
- (IBAction)ugc:(id)sender;
// 评论页
- (IBAction)comment:(id)sender;
// 收藏页
- (IBAction)repin:(id)sender;

@end
