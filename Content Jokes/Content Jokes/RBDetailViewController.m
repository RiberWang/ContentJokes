//
//  RBDetailViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-24.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBDetailViewController.h"
#import "RBDetailModel.h"
#import "RBDetailTopComModel.h"
#import "RBUserInfoViewController.h"

@interface RBDetailViewController () <UITextFieldDelegate>
{
    UIView *_tabBarView;
}

@end

@implementation RBDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 底部tabBar视图隐藏
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"详情";
    [self makeView];
    
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
}

- (void)networkChanged:(NSNotification *)notification {
    Reachability *currentReach = [notification object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:currentReach];
}

- (BOOL)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
        {
            self.netIsAvaild = NO;
        }
            break;
        case ReachableViaWWAN:
        {
            self.netIsAvaild = YES;
        }
            break;
        case ReachableViaWiFi:
        {
            self.netIsAvaild = YES;
        }
            break;
        default:
            break;
    }
    
    return self.netIsAvaild;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startRequest];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
}

#pragma mark - 自定义tabBar
- (void)makeTabBarView {
    // 导航条下的坐标为0,0 所以_tabBarView的坐标就是整个WINDOW_SIZE高度-64-自身的高度(49)
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, WINDOW_SIZE.height-49-self.navigationController.navigationBar.frame.size.height-20, WINDOW_SIZE.width, 49)];
    _tabBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_tabBarView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7.5, WINDOW_SIZE.width-20, 34)];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.font = [UIFont systemFontOfSize:13];
    textField.placeholder = @"期待你的神评论";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"write.png"]];
    imgView.frame = CGRectMake(0, 0, 24, 24);
    textField.leftViewMode = UITextFieldViewModeUnlessEditing;
    textField.leftView = imgView;
    [_tabBarView addSubview:textField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.tableView endEditing:YES];
}

- (void)makeView {
    //导航条下的坐标为0,0
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.recentComArray = [[NSMutableArray alloc] init];
    self.topComArray = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB(234, 234, 234);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 44);
    //btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    // 详情页面有个举报按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 44);
    [rightBtn setTitle:@"举报" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self makeTabBarView];
}

- (void)leftBackButton:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUrl {
    
}

- (void)startRequest {
    [self setUrl];
    
    [RBMyConnection connectionWithUrl:_url andFinishBlock:^(NSData *data) {
        [self endRequest:data];
    } andFailedBlock:^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据请求失败,请检查网络连接!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        // 下方出现一个提示label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, WINDOW_SIZE.height, WINDOW_SIZE.width-100, WINDOW_SIZE.height)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;
        label.backgroundColor = [UIColor darkGrayColor];
        label.tag = 1;
        label.text = @"没有网络呦!请检查网络连接!";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:label];
        
        [UIView animateWithDuration:1 animations:^{
            label.alpha = 0.8;
            // 导航条下坐标点为0,0
            label.frame = CGRectMake(50, WINDOW_SIZE.height-40-49-64-20, WINDOW_SIZE.width-100, 30);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(labelRemoveFromSuperView) withObject:nil afterDelay:1];
        }];
    }];
}

- (void)labelRemoveFromSuperView {
    UILabel *label = (UILabel *)[self.view viewWithTag:1];
    label.alpha = 0;
    [label removeFromSuperview];
}

- (void)endRequest:(NSData *)data {
    [self.topComArray removeAllObjects];
    [self.recentComArray removeAllObjects];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *dataDic = dic[@"data"];
    
    //添加热门评论
    for (NSDictionary *top_commentsDic in dataDic[@"top_comments"]) {
        RBDetailTopComModel *topModel = [[RBDetailTopComModel alloc] init];
        [topModel setValuesForKeysWithDictionary:top_commentsDic];
        [self.topComArray addObject:topModel];
    }
    
    //添加新鲜评论
    for (NSDictionary *recent_commentsDic in dataDic[@"recent_comments"]) {
        RBDetailModel *detailModel = [[RBDetailModel alloc] init];
        [detailModel setValuesForKeysWithDictionary:recent_commentsDic];
        [self.recentComArray addObject:detailModel];
    }

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.topComArray.count;
    }
    return self.recentComArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    
    RBDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL"];
    if (detailCell == nil) {
        detailCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBDetailCell class]) owner:self options:nil] lastObject];
    }
    
    if (indexPath.section == 1) {
        RBDetailTopComModel *topModel = self.topComArray[indexPath.row];
        [detailCell showInDetailTopCell:topModel];
        //动态设置detail中控件的位置
        CGRect frame = detailCell.commentLabel.frame;
        frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:topModel.text andLabelWidth:280 andLabelFontSize:15].height);
        detailCell.commentLabel.frame = frame;
        
        // 设置点击进入用户页的按钮
        detailCell.userInfoButton.tag = [topModel.user_id intValue];
        [detailCell.userInfoButton setTitle:topModel.user_name forState:UIControlStateNormal];
        
    } else {
        RBDetailModel *detailModel = self.recentComArray[indexPath.row];
        [detailCell showInDetailCell:detailModel];
        
        //动态设置detail中控件的位置
        CGRect frame = detailCell.commentLabel.frame;
        frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:detailModel.text andLabelWidth:280 andLabelFontSize:15].height);
        detailCell.commentLabel.frame = frame;
        
        // 设置点击进入用户页的按钮
        detailCell.userInfoButton.tag = [detailModel.user_id intValue];
        [detailCell.userInfoButton setTitle:detailModel.user_name forState:UIControlStateNormal];
    }
    
    // 给进入用户页的按钮添加事件
    [detailCell.userInfoButton addTarget:self action:@selector(gotoUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
    
    return detailCell;
}

#pragma mark - 进入用户详情页
- (void)gotoUserInfoVC:(UIButton *)button {
    RBUserInfoViewController *userInfoVC = [[RBUserInfoViewController alloc] init];
    userInfoVC.title = button.currentTitle;
    userInfoVC.userId = [NSString stringWithFormat:@"%ld", (long)button.tag];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - 表格的行高
//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return 0;
    } else if (indexPath.section == 1) {
        //热门评论
        RBDetailTopComModel *topModel = self.topComArray[indexPath.row];
        
        return ceil([RBMixed setLabelFrameAccordingTextContent:topModel.text andLabelWidth:280 andLabelFontSize:15].height)+20+15+5*10;//5个间隙 都为10 最后一个是背景和cell的间隙
    }
    //新鲜评论
    RBDetailModel *detailModel = self.recentComArray[indexPath.row];
    
    return ceil([RBMixed setLabelFrameAccordingTextContent:detailModel.text andLabelWidth:280 andLabelFontSize:15].height)+20+15+5*10;//5个间隙 都为10
}

//设置区的标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return nil;
//    } else if (section == 1) {
//        if (self.topComArray.count == 0) {
//            return nil;
//        }
//        return [NSString stringWithFormat:@"热门评论(%ld)", self.topComArray.count];
//    }
//    if (self.recentComArray.count == 0) {
//        return nil;
//    }
//    return [NSString stringWithFormat:@"新鲜评论(%ld)", self.recentComArray.count];
//}

#pragma mark - 自定义表格的头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.topComArray.count == 0 && self.recentComArray.count == 0 && section == 1) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        imgView.image = [UIImage imageNamed:@"picture_sofa.png"];
        
        return imgView;
    }
    
    if (section == 1) {
        // 添加背景
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, 30)];
        view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        if (self.topComArray.count == 0) {
            return nil;
        }
        // 设置区的标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        label.text = [NSString stringWithFormat:@"热门评论(%ld)", (unsigned long)self.topComArray.count];
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        
        return view;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, 30)];
    view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    if (self.recentComArray.count == 0) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    label.text = [NSString stringWithFormat:@"新鲜评论(%ld)", (unsigned long)self.recentComArray.count];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    
    return view;
}

#pragma mark - 表格分区的头部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if (self.topComArray.count == 0 && self.recentComArray.count == 0 && section == 1) {
        return 230;
    }
    if (self.topComArray.count == 0 && self.recentComArray.count == 0 && section == 2) {
        return 0;
    }
    if (self.topComArray.count == 0 && self.recentComArray.count != 0 && section == 1) {
        return 0;
    }

    return 30;
}

#pragma mark - textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 设置UITextField的左视图的x坐标
/*
-(id)initWithFrame:(CGRect)frame Icon:(UIImageView*)icon{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }	return self;
}
-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}

 - (void)dd {
    UIImage *usernameImage = [UIImage imageNamed:@"user"];
    UIImageView *usernameIcon = [[UIImageView alloc] initWithImage:usernameImage];
    usernameIcon.frame = CGRectMake(0, 0, 20, 20);
    self.username = [[YLSTextField alloc] initWithFrame:CGRectMake(0, 0, 240, 30) Icon:usernameIcon];
    self.username.placeholder = @"用户名";
    self.username.borderStyle = UITextBorderStyleRoundedRect;
    self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.username setKeyboardType:UIKeyboardTypeNumberPad];
    //关键就是定义UITextField的子类，并覆盖其leftViewRectForBounds方法
}
*/

@end
