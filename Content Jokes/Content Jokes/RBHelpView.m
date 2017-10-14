//
//  RBHelpView.m
//  Content Jokes
//
//  Created by qianfeng on 15-2-26.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBHelpView.h"

@implementation RBHelpView 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self makeView];
    }
    return self;
}

- (void)makeView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width*3, self.frame.size.height);
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    //_scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < 3; i++) {
        NSString *name = [NSString stringWithFormat:@"picture%d_intros-568h.png", i+1];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = [UIImage imageNamed:name];
        [_scrollView addSubview:imageView];
        
        //给最后一张图片添加手势
        if (i == 2) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
            [imageView addGestureRecognizer:tap];
            
//            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe)];
//            swipe.direction = UISwipeGestureRecognizerDirectionLeft;
//            [imageView addGestureRecognizer:swipe];
        }
    }
}

- (void)tap {
    if (self.clickBlock) {
        self.clickBlock();
    }
    [self removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    if (x > self.bounds.size.width*2+10) {
        _isGo = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_isGo) {
        if (self.clickBlock) {
            self.clickBlock();
        }
        
        [self removeFromSuperview];
    }
    else
    {
        
    }
}

@end
