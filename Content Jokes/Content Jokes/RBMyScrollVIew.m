//
//  RBMyScrollVIew.m
//  Content Jokes
//
//  Created by riber on 15/12/21.
//  Copyright © 2015年 Riber. All rights reserved.
//

#import "RBMyScrollVIew.h"

@implementation RBMyScrollVIew

- (id)initWithFrame:(CGRect)frame andTitlesArray:(NSArray *)array {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    
    return self;
}

- (void)initSubViews {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    //_pageControl = [[UIPageControl alloc] initWithFrame:<#(CGRect)#>];
}

@end
