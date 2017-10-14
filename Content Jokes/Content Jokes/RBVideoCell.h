//
//  RBVideoCell.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-26.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "RBJokeCell.h"

@class RBVideoModel;

@interface RBVideoCell : RBJokeCell

@property(nonatomic, strong) IBOutlet UIImageView *avatarImage;//用户头像
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;//用户名
@property(nonatomic, strong) IBOutlet UILabel *contentLabel;//评论内容

@property(nonatomic, strong) IBOutlet UIView *bgView;//下面三个label放在这个上面 方便图文混排(可以不需要 xib有属性可以设置autosizing 不需要代码)
@property(nonatomic, strong) IBOutlet UILabel *diggLabel;//赞
@property(nonatomic, strong) IBOutlet UILabel *buryLabel;//踩
@property(nonatomic, strong) IBOutlet UILabel *commentLabel;//评论

@property(nonatomic, strong) IBOutlet UIView *playCountAndTimebgView;//播放次数和总时间的背景
@property(nonatomic, strong) IBOutlet UILabel *playCountLabel;
@property(nonatomic, strong) IBOutlet UILabel *totalTime;
@property(nonatomic, strong) IBOutlet UIProgressView *progressView;

@property(nonatomic, strong) IBOutlet UIButton *playBtn;

@property (strong, nonatomic) IBOutlet UIButton *userInfoButton;
@property(nonatomic, strong) IBOutlet UIButton *nonClickButton;

@property (nonatomic, weak) IBOutlet UIView *playerBgView;
@property(nonatomic, strong) RBPlayerView *playerView;
@property(nonatomic, strong) AVPlayer *player;

//创建cell
+ (id)videoCell;

//显示videoCell的信息
- (void)showInVideoCell:(RBVideoModel *)videoModel;

@end
