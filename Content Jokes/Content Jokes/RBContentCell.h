//
//  RBContentCell.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBJokeCell.h"
#import "Reachability.h"
#import "EGOImageView.h"

@class RBContentModel;
@class RBImageModel;

@interface RBContentCell : RBJokeCell

@property(nonatomic, strong) IBOutlet UIImageView *avatarImage;//用户头像
@property(nonatomic, strong) IBOutlet UIImageView *statusImage;//状态
@property(nonatomic, strong) IBOutlet EGOImageView *contentImage;//发表的图片
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;//用户名

@property(nonatomic, strong) IBOutlet UILabel *contentLabel;//评论内容

@property(nonatomic, strong) IBOutlet UIView *bgView;//下面三个label放在这个上面 方便图文混排(可以不需要 xib有属性可以设置autosizing 不需要代码)
@property(nonatomic, strong) IBOutlet UILabel *diggCountLabel;//赞个数
@property(nonatomic, strong) IBOutlet UILabel *buryCountLabel;//踩个数
@property(nonatomic, strong) IBOutlet UILabel *commentCountLabel;//评论个数

@property (strong, nonatomic) IBOutlet UIButton *userInfoButton;
@property(nonatomic, strong) IBOutlet UIButton *nonClickButton;

@property(nonatomic, strong) IBOutlet UIButton *titleButton; // 文字开始的图片

@property (nonatomic, strong) Reachability *reachability; // 网络类
@property (nonatomic, assign) BOOL netIsConnect; // 网络是否可用

@property (nonatomic, copy) void(^sharedButtonBlock)(); // 分享按钮
@property (nonatomic, copy) void(^copyContentBlock)(UILongPressGestureRecognizer *longPress); // 复制文字

//调用该方法用来显示cell的数据
//显示段子cell的内容
- (void)showInContentCell:(RBContentModel *)contentModel;
//显示图片cell的内容
- (void)showInImageCell:(RBImageModel *)imageModel;

- (IBAction)nonClickBtn:(id)sender;

@end
