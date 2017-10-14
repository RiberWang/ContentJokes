//
//  RBPlayerView.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-28.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBPlayerView.h"

@implementation RBPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player {
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    [layer setPlayer:player];
}

@end
