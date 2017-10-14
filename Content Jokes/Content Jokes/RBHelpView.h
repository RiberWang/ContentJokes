//
//  RBHelpView.h
//  Content Jokes
//
//  Created by qianfeng on 15-2-26.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBHelpView : UIView <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    BOOL _isGo;
}

@property(nonatomic, copy) void(^clickBlock)();

@end
