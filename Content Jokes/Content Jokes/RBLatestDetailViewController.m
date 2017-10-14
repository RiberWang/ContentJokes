//
//  RBLatestDetailViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-1.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBLatestDetailViewController.h"
#import "RBLatestCell.h"

@interface RBLatestDetailViewController ()

@end

@implementation RBLatestDetailViewController

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailCell *detailCell = (RBDetailCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        RBContentCell *contentCell = (RBContentCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        contentCell.titleButton.hidden = NO;
        
        contentCell.netIsConnect = self.netIsAvaild;
        [contentCell showInContentCell:self.contentModel];
        
        contentCell.contentLabel.text = [NSString stringWithFormat:@"\t\t\t%@", self.contentModel.content];
        [contentCell.titleButton setTitle:self.title forState:UIControlStateNormal];
        
        // 属性字符串添加下划线
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:contentCell.titleButton.currentTitle];
        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [contentCell.titleButton.currentTitle length])]; //NSUnderlineStyleAttributeName
        contentCell.titleButton.titleLabel.attributedText = string;
        
        //动态设置cell中控件的位置
        CGRect frame = contentCell.contentLabel.frame;
        frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:self.contentModel.content andLabelWidth:280 andLabelFontSize:15].height);
        contentCell.contentLabel.frame = frame;
        
        return contentCell;
    }
    return detailCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        return self.textLabelHeight+20+30+10+20+10+10;//10+20+10+10间隔
    }
    
    return height;
}

@end
