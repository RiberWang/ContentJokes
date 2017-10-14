//
//  RBAgoCell.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-1.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBAgoCell.h"
#import "RBLatestModel.h"

@implementation RBAgoCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showInAgoCell:(RBLatestModel *)latestModel {
    self.titleLabel.text = latestModel.title;
    self.userCountLabel.text = [NSString stringWithFormat:@"%@人参加", latestModel.user_count];
    self.groupCountLabel.text = [NSString stringWithFormat:@"%@条内容", latestModel.group_count];
    [self.imgView setImageWithURL:[NSURL URLWithString:latestModel.url]];
}

@end
