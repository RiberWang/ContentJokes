//
//  RBLatestCell.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-1.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBLatestCell.h"
#import "RBLatestModel.h"

@implementation RBLatestCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showInLatestCell:(RBLatestModel *)latestModel {
    [self.imgView setImageWithURL:[NSURL URLWithString:latestModel.url]];
    self.nameLabel.text = [NSString stringWithFormat:@"发起人:%@", latestModel.activity_name];
    //NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    int time = [latestModel.end_time intValue] - [latestModel.start_time intValue];
    
    int days = time/(24*60*60);
    self.contentLabel.text = latestModel.text;
    self.daysLabel.text = [NSString stringWithFormat:@"剩余%d天", days];
}

@end
