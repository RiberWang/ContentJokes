//
//  RBImageDetailViewController.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-31.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBDetailViewController.h"

@interface RBImageDetailViewController : RBDetailViewController <UIScrollViewDelegate>

@property(nonatomic, strong) RBImageModel *imageModel;//接收点击的图片段子的数据

@property (nonatomic, strong) UIScrollView *scrollView; // 小图图片放大后的背景视图

- (void)addGesture:(UIImageView *)imgView;

@end
