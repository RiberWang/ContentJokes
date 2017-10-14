//
//  RBAgoDetailViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-5.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBAgoDetailViewController.h"
#import "RBLatestCell.h"
#import "RBLatestModel.h"
#import "RBContentModel.h"

@interface RBAgoDetailViewController ()

@end

@implementation RBAgoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createNavBarItem {
    //返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 44);
    [btn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)createUI {
    self.edgesForExtendedLayout = NO;
    self.latestArray = [[NSMutableArray alloc] init];

    self.latestTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height-64) style:UITableViewStyleGrouped];
    self.latestTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.latestTableView.backgroundColor = RGB(234, 234, 234);
    self.latestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.latestTableView.delegate = self;
    self.latestTableView.dataSource = self;
    self.latestTableView.tag = 326; // 这句话不写 数据不会显示 调了好久这个bug
    [self.view addSubview:self.latestTableView];
}

- (void)setUrl {
    self.url = [NSString stringWithFormat:FIND_PATH_AGO_DETAIL, _categoryId, FIND_PATH_AGO_DETAIL_PART];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RBLatestCell *latestCell = (RBLatestCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

        // 设置原来的按钮隐藏 大的分享按钮显示
        latestCell.joinButton.hidden = YES;
        latestCell.sharedButton.hidden = YES;
        latestCell.bigSharedButton.hidden = NO;
        
        // 填充数据
        [latestCell showInLatestCell:self.latestModel];

        // 重新赋值
        latestCell.nameLabel.text = [NSString stringWithFormat:@"%@人参加", self.latestModel.user_count];
        latestCell.daysLabel.text = @"已结束";
        
        return latestCell;
    }
    RBContentCell *contentCell = (RBContentCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

    return contentCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 10;
    }
}

@end
