//
//  RBContentViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBContentViewController.h"
#import "RBContentModel.h"
#import "RBContentCell.h"
#import "MJRefresh.h"
#import "RBContentDetailViewController.h"

@interface RBContentViewController () {
    BOOL _isDownRefresh;
    BOOL _isUpRefresh;
}

@end

@implementation RBContentViewController

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
    
    [self setDownRefresh:YES];
    [self setUpRefresh:YES];
    [self setNavBarButton:YES];
    
    NSArray *array = [self.manager selectContentJokes];
    
    if (array) {
        self.dataSources = (NSMutableArray *)array;
    }
    else
    {
        
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 非首次进入自动刷新
    if ([userDefaults valueForKey:@"isNotFirst"]) {
        [self setBeginRefresh:YES]; // 首次进入可能会有点卡顿 在加载数据呢
    }
}

- (void)setUrl {
    NSTimeInterval min_time = [[NSDate date] timeIntervalSince1970];
    self.url = [NSString stringWithFormat:CONTENT_PATH, CONTENT_PATH_PART1, (int)min_time, CONTENT_PATH_PART2];
}

- (void)titleButtonClick:(UIButton *)button {
    self.category_id = @"1";
    [super titleButtonClick:button];
}

//重写父类中的方法
- (void)endRequestWithData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //注意这是一个大字典
    NSDictionary *firstDataDic= dic[@"data"];
    for (NSDictionary *secondDataDic in firstDataDic[@"data"]) {
        RBContentModel *contentModel = [[RBContentModel alloc] init];
        NSDictionary *groupDic = secondDataDic[@"group"];

        if (groupDic) {
            [contentModel setValuesForKeysWithDictionary:groupDic];
            NSDictionary *userDic = groupDic[@"user"];
            [contentModel setValuesForKeysWithDictionary:userDic];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userDic[@"avatar_url"]]]];
            contentModel.avatarImage = image;
            
            // 新增
            if (![self.dataSources containsObject:contentModel]) {
                [self dataSourcesAddModel:contentModel];
                [self.manager insertModel:contentModel];
            }
//            if (self.dataSources.count >= 20) {
//                [self.dataSources removeObject:contentModel];
//                [manager deleteModel:contentModel];
//            }
        } else if (secondDataDic[@"ad"]) {
            // 广告不作处理
            NSDictionary *adDic = secondDataDic[@"ad"];
            NSLog(@"--------------------------------%@", adDic);
        }
    }
        //数据改变 刷新表格
    [super endRequestWithData:data];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"CONTENT"];
    if (contentCell == nil) {
        contentCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBContentCell class]) owner:self options:nil] lastObject];
    }
    
    RBContentModel *contentModel = self.dataSources[indexPath.row];
    
    contentCell.netIsConnect = self.netIsAvaild;
    //显示cell上的信息
    [contentCell showInContentCell:contentModel];
    
    // 添加复制功能
    typeof(contentCell) myContentCell = contentCell;
    [contentCell setCopyContentBlock:^(UILongPressGestureRecognizer *longPress){
        // 手势开始的时候 复制
        if (longPress.state == UIGestureRecognizerStateBegan) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = myContentCell.contentLabel.text;
            NSLog(@"复制成功");
        }
        else if (longPress.state == UIGestureRecognizerStateEnded)
        {
            [self copyContentsAlertLable];
        }
    }];
    
    //设置button的长度
    CGRect rect = [RBMixed setButtonFrameWithLabelText:contentModel.name andLabelWidth:190 andLabelFontSize:17];
    contentCell.userInfoButton.frame = CGRectMake(contentCell.userInfoButton.frame.origin.x, contentCell.userInfoButton.frame.origin.y, rect.size.width, contentCell.userInfoButton.frame.size.height);

    //为button添加事件
    [contentCell.userInfoButton addTarget:self action:@selector(pushToUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
    // 点击的按钮的tag值就是用户的id 把这个传给用户详情页 解析的网址需要用户id
    contentCell.userInfoButton.tag = [contentModel.user_id intValue];
    // 点击的按钮的标题就是用户的名字 把这个传给用户详情页 详情页导航上的标题
    [contentCell.userInfoButton setTitle:[NSString stringWithFormat:@"%@", contentModel.name] forState:UIControlStateNormal];
    
    //设置不可点击的button的frame
    contentCell.nonClickButton.frame = CGRectMake(contentCell.userInfoButton.frame.origin.x+contentCell.userInfoButton.frame.size.width, 0, 300-contentCell.userInfoButton.frame.size.width, 50);
    
    //为不可点击的button添加事件 使cell右上方空白处不可被点击
    //[contentCell.nonClickButton addTarget:self action:@selector(nonClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([contentModel.digg_count doubleValue] >= 300) {
        contentCell.statusImage.hidden = NO;
        contentCell.statusImage.image = [UIImage imageNamed:@"hoticon_textpage.png"];
    } else if ([contentModel.digg_count intValue] >= 400) {
        contentCell.statusImage.hidden = NO;
        contentCell.statusImage.image = [UIImage imageNamed:@"history_textpage.png"];
    } else {
        contentCell.statusImage.hidden = YES;
    }
    
    //动态设置cell中控件的位置
    CGRect frame = contentCell.contentLabel.frame;
    frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:contentModel.content andLabelWidth:280 andLabelFontSize:15].height);
    contentCell.contentLabel.frame = frame;
    
    return contentCell;
}

//- (void)copyLabelRemove:(UILabel *)label {
//    [label removeFromSuperview];
//}

#pragma mark - 进入用户详情页 在父类中实现

#pragma mark - 动态设置表格单元格的高度
//动态设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBContentModel *contentModel = self.dataSources[indexPath.row];

    return ceil([RBMixed setLabelFrameAccordingTextContent:contentModel.content andLabelWidth:280 andLabelFontSize:15].height)+20+30+4*10;//10+10+10+10间隔
}

#pragma mark - 选中每行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBContentModel *contentModel = self.dataSources[indexPath.row];
    RBContentDetailViewController *detailVC = [[RBContentDetailViewController alloc] init];
    detailVC.contentModel = contentModel;
    NSLog(@"%@", contentModel.group_id);
    detailVC.textLabelHeight = ceil([RBMixed setLabelFrameAccordingTextContent:contentModel.content andLabelWidth:280 andLabelFontSize:15].height);
    /*
     //增加动画效果 水纹效果
     CATransition *transition = [CATransition animation];
     transition.duration = 2;
     transition.type = @"rippleEffect";
     [self.navigationController.view.layer addAnimation:transition forKey:nil];
     */
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
