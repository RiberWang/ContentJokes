//
//  RBUserInfoViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-28.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBUserInfoViewController.h"
#import "RBUserInfoModel.h"
#import "RBQuestionViewController.h"
#import "RBUgcViewController.h"
#import "RBCommentViewController.h"
#import "RBRepinViewController.h"

@interface RBUserInfoViewController ()

@end

@implementation RBUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.hidesBottomBarWhenPushed = YES;
        //64 224 15 2  71 217 2 15
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 22, 44);
    [backBtn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    // 这个页面有个举报按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 20);
    [rightBtn setTitle:@"举报" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self startRequest];
}

- (void)pressBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startRequest {
    [RBMyConnection connectionWithUrl:[NSString stringWithFormat:USERINFO_PATH, _userId, USERINFO_PATH_PART] andFinishBlock:^(NSData *data) {
        NSLog(@"%@",[NSString stringWithFormat:USERINFO_PATH, _userId, USERINFO_PATH_PART]);
        [self endRequestWithData:data];
    } andFailedBlock:^{
        NSLog(@"用户信息获取失败");
    }];
}

- (void)endRequestWithData:(NSData *)data {
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *dataDic = dic[@"data"];
    RBUserInfoModel *userInfoModel = [[RBUserInfoModel alloc] init];
    [userInfoModel setValuesForKeysWithDictionary:dataDic];
    // 显示
    [self.headImage setImageWithURL:[NSURL URLWithString:userInfoModel.avatar_url]];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 15;
    self.nameLabel.text = userInfoModel.name;
    self.userId = userInfoModel.user_id;//用户id
    self.followersLabel.text = [NSString stringWithFormat:@"%@", userInfoModel.followers];
    self.followingsLabel.text = [NSString stringWithFormat:@"%@", userInfoModel.followings];
    self.pointLabel.text = [NSString stringWithFormat:@"积分:%@", userInfoModel.point];
    self.desLabel.text = [NSString stringWithFormat:@"%@", userInfoModel.userDescription];
    self.ugcLabel.text = [NSString stringWithFormat:@"%@", userInfoModel.ugc_count];
    self.commentLabel.text = [NSString stringWithFormat:@"%@", userInfoModel.comment_count];
    self.repinLabel.text = [NSString stringWithFormat:@"%@", userInfoModel.repin_count];
}

// 点击进入积分页面 查看常见问题
- (IBAction)gotoQuestion:(id)sender {
    RBQuestionViewController *questionVC = [[RBQuestionViewController alloc] init];
    questionVC.title = @"常见问题";
    [self.navigationController pushViewController:questionVC animated:YES];
}

// 添加关注
- (IBAction)addFollowing:(id)sender {
    NSLog(@"添加关注成功");
}

// 发悄悄话
- (IBAction)sendPrivateLetter:(id)sender {
    NSLog(@"发送私信");
}

// 投稿
- (IBAction)ugc:(id)sender {
    RBUgcViewController *ugcVC = [[RBUgcViewController alloc] init];
    ugcVC.userId = self.userId;
    ugcVC.title = @"Ta 的投稿";
    [self.navigationController pushViewController:ugcVC animated:YES];
}

// 评论
- (IBAction)comment:(id)sender {
    RBCommentViewController *commentVC = [[RBCommentViewController alloc] init];
    commentVC.userId = self.userId;
    commentVC.title = @"Ta 的评论";
    [self.navigationController pushViewController:commentVC animated:YES];
}

// 收藏
- (IBAction)repin:(id)sender {
    RBRepinViewController *repinVC = [[RBRepinViewController alloc] init];
    repinVC.userId = self.userId;
    repinVC.title = @"Ta 的收藏";
    [self.navigationController pushViewController:repinVC animated:YES];
}

@end
