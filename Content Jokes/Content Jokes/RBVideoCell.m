//
//  RBVideoCell.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-26.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBVideoCell.h"
#import "RBVideoModel.h"
#import "UIImageView+WebCache.h"

@implementation RBVideoCell

+ (id)videoCell {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBVideoCell class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    // Initialization code
    
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showInVideoCell:(RBVideoModel *)videoModel {
    [self.avatarImage setImageWithURL:[NSURL URLWithString:videoModel.avatar_url]];
    self.contentLabel.hidden = YES;
    self.nameLabel.text = videoModel.name;
    if (videoModel.content.length != 0) {
        self.contentLabel.text = videoModel.content;
    }
    
    self.diggLabel.text = [NSString stringWithFormat:@"%@", videoModel.digg_count];
    self.buryLabel.text = [NSString stringWithFormat:@"%@", videoModel.bury_count];
    self.commentLabel.text = [NSString stringWithFormat:@"%@", videoModel.comment_count];
    self.playCountLabel.text = [NSString stringWithFormat:@"%@次播放", videoModel.play_count];
    int mm = [videoModel.duration intValue]/60;
    int ss = [videoModel.duration intValue]%60;
    self.totalTime.text = [NSString stringWithFormat:@"%.2d:%.2d", mm, ss];
}

@end
