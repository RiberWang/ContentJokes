//
//  RBContentDetailViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-31.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBContentDetailViewController.h"
#import "RBContentModel.h"
#import "RBContentCell.h"//ContentVC和ImageVC共用一个cell

@interface RBContentDetailViewController ()

@end

@implementation RBContentDetailViewController

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

- (void)setUrl {
    self.url = [NSString stringWithFormat:CONTENT_DETAIL_PATH, self.contentModel.group_id, CONTENT_DETAIL_PATH_PART];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailCell *detailCell = (RBDetailCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // 第0个分区用的是contentCell
    if (indexPath.section == 0) {
        RBContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CONTENT"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBContentCell class]) owner:self options:nil] lastObject];
        }
        
        cell.netIsConnect = self.netIsAvaild;
        //显示第一个分区cell的信息
        [cell showInContentCell:self.contentModel];
        //动态设置cell中控件的位置
        cell.contentLabel.frame = CGRectMake(cell.contentLabel.frame.origin.x, cell.contentLabel.frame.origin.y, cell.contentLabel.frame.size.width, self.textLabelHeight);
        
        // 用户信息页
        // 设置点击进入用户页的按钮
        cell.userInfoButton.tag = [self.contentModel.user_id intValue];
        [cell.userInfoButton setTitle:self.contentModel.name forState:UIControlStateNormal];
        [cell.userInfoButton addTarget:self action:@selector(gotoUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return detailCell;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        
        return self.textLabelHeight+20+15+5*10; // 10+10+10+10间隔 还有1个10是底部的10个间隔
    }
    
    return height;
}


@end
