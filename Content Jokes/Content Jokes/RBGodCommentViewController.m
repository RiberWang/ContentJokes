//
//  RBGodCommentViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-5.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBGodCommentViewController.h"
#import "RBCommentModel.h"
#import "RBDetailCell.h"

@interface RBGodCommentViewController ()

@end

@implementation RBGodCommentViewController

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
    self.url = FIND_PATH_GOD_COMMENT;
}

#pragma mark - 解析数据
- (void)endRequestWithData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *firstDataDic = dic[@"data"];
    for (NSDictionary *secondDataDic in firstDataDic[@"data"]) {
        // 评论内容
        NSDictionary *commentDic = secondDataDic[@"comment"];
        RBCommentModel *commentModel = [[RBCommentModel alloc] init];
        [commentModel setValuesForKeysWithDictionary:commentDic];
        
        // 被评论的内容
        NSDictionary *groupDic = secondDataDic[@"group"];
        [commentModel setValuesForKeysWithDictionary:groupDic];
        NSDictionary *userDic = groupDic[@"user"];
        [commentModel setValuesForKeysWithDictionary:userDic];
        [self.dataSources addObject:commentModel];
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailCell *detailCell = (RBDetailCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [detailCell showInGodCommentDetailCell:self.dataSources[indexPath.row]];

    return detailCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBCommentModel *commentModel = self.dataSources[indexPath.row];
    int commentHeight = [RBMixed setLabelFrameAccordingTextContent:commentModel.text andLabelWidth:280 andLabelFontSize:15].height;
    int contentHeight = [RBMixed setLabelFrameAccordingTextContent:commentModel.content andLabelWidth:260 andLabelFontSize:13].height;
    return commentHeight + contentHeight + 20 + 20 + 15 + 6*10+10; // 5个间隙
}

@end
