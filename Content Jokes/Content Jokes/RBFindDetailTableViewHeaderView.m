//
//  RBFindDetailTableViewHeaderView.m
//  Content Jokes
//
//  Created by qianfeng on 15-3-5.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBFindDetailTableViewHeaderView.h"

@implementation RBFindDetailTableViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)findDetailTableViewHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBFindDetailTableViewHeaderView class]) owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
