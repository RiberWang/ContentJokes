//
//  RBAgoCell.h
//  Content Jokes
//
//  Created by qianfeng on 15-3-1.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBJokeCell.h"

@class RBLatestModel;

@interface RBAgoCell : RBJokeCell

@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *userCountLabel;
@property(nonatomic, strong) IBOutlet UILabel *groupCountLabel;
@property(nonatomic, strong) IBOutlet UIImageView *imgView;

- (void)showInAgoCell:(RBLatestModel *)latestModel;

@end
