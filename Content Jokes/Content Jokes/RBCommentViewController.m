//
//  RBCommentViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-2-3.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBCommentViewController.h"
#import "RBDetailCell.h"
#import "RBCommentModel.h"

@interface RBCommentViewController ()

@end

@implementation RBCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 44);
    [btn setImage:[UIImage imageNamed:@"leftBackButtonFGNormal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self setNavBarButton:NO];
    [self setUrl];
    [self startRequest];
}

- (void)leftBackButton:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUrl {
    self.url = [NSString stringWithFormat:COMMENT_PATH, _userId, COMMENT_PATH_PART];
}

- (void)createUI {
    [super createUI];
    self.tableView.frame = CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height-64);
}

- (void)endRequestWithData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    for (NSDictionary *dataDic in dic[@"data"]) {
        RBCommentModel *commentModel = [[RBCommentModel alloc] init];
        [commentModel setValuesForKeysWithDictionary:dataDic];
        [self.dataSources addObject:commentModel];
    }
    
    [super endRequestWithData:data];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL"];
    if (detailCell == nil) {
        detailCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBDetailCell class]) owner:self options:nil] lastObject];
    }
    
    // 显示数据
    RBCommentModel *commentModel = self.dataSources[indexPath.row];
    [detailCell showInDetailCellOfUserInfoComment:commentModel];
    
    // 混排 设置评论label的frame
    CGRect commentFrame = detailCell.commentLabel.frame;
    commentFrame.size.height = [RBMixed setLabelFrameAccordingTextContent:commentModel.text andLabelWidth:280 andLabelFontSize:15].height;
    detailCell.commentLabel.frame = commentFrame;
    
    // 设置内容label的frame
    detailCell.contentLabel.frame = CGRectMake(detailCell.contentLabel.frame.origin.x, detailCell.commentLabel.frame.origin.y + detailCell.commentLabel.frame.size.height + 10, detailCell.contentLabel.frame.size.width, ceil([RBMixed setLabelFrameAccordingTextContent:commentModel.content andLabelWidth:260 andLabelFontSize:13].height));
    
    return detailCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBCommentModel *commentModel = self.dataSources[indexPath.row];
    int commentHeight = [RBMixed setLabelFrameAccordingTextContent:commentModel.text andLabelWidth:280 andLabelFontSize:15].height;
    int contentHeight = [RBMixed setLabelFrameAccordingTextContent:commentModel.content andLabelWidth:260 andLabelFontSize:13].height;
    return commentHeight + contentHeight + 20 + 15 + 5*10+10; // 5个间隙
}

@end
