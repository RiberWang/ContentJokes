//
//  RBLatestCell.h
//  Content Jokes
//
//  Created by qianfeng on 15-3-1.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBJokeCell.h"

@class RBLatestModel;

@interface RBLatestCell : RBJokeCell

@property(nonatomic, strong) IBOutlet UIImageView *imgView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *daysLabel;
@property(nonatomic, strong) IBOutlet UILabel *contentLabel;
@property(nonatomic, strong) IBOutlet UIButton *joinButton;
@property(nonatomic, strong) IBOutlet UIButton *sharedButton;
@property(nonatomic, strong) IBOutlet UIButton *bigSharedButton;

- (void)showInLatestCell:(RBLatestModel *)latestModel;

@end
