//
//  RBFindDetailTableViewHeaderView.h
//  Content Jokes
//
//  Created by qianfeng on 15-3-5.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBFindDetailTableViewHeaderView : UIView

@property(nonatomic, strong) IBOutlet UIImageView *iconImgView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *placeholderLabel;

// RBFindDetailViewController 中调用
+ (id)findDetailTableViewHeaderView;

@end
