//
//  RBContentCell.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBContentCell.h"
#import "RBContentModel.h"
#import "RBImageModel.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation RBContentCell

- (void)awakeFromNib
{
    // Initialization code
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = 15;
    self.statusImage.hidden = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGR:)];
    longPress.minimumPressDuration = 0.3;
    [self addGestureRecognizer:longPress];
    
    // 使用label添加下划线
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20-1, 80, 1)];
//    label.backgroundColor = [UIColor redColor];
//    [self.titleButton addSubview:label];
}

- (void)longPressGR:(UILongPressGestureRecognizer *)longPress {
    if (self.copyContentBlock) {
        self.copyContentBlock(longPress);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 显示内容段子
- (void)showInContentCell:(RBContentModel *)contentModel {
//    if (!self.netIsConnect) {
//        self.avatarImage.image = contentModel.avatarImage;
//    } else {
//        [self.avatarImage setImageWithURL:[NSURL URLWithString:contentModel.avatar_url] placeholderImage:[UIImage imageNamed:@"defaulthead.png"]];
//    }
    
    self.avatarImage.image = contentModel.avatarImage;

    self.contentImage.hidden = YES;
    self.nameLabel.text = contentModel.name;
    self.contentLabel.text = contentModel.content;
    if (contentModel.content == nil) {
        self.contentLabel.text = contentModel.title;
    }
    self.diggCountLabel.text = [NSString stringWithFormat:@"%@", contentModel.digg_count];
    self.buryCountLabel.text = [NSString stringWithFormat:@"%@", contentModel.bury_count];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", contentModel.comment_count];
}

// 显示图片段子
- (void)showInImageCell:(RBImageModel *)imageModel {
//    if (!self.netIsConnect) {
//        self.avatarImage.image = imageModel.avatarImage;
//    } else {
//        [self.avatarImage setImageWithURL:[NSURL URLWithString:imageModel.avatar_url] placeholderImage:[UIImage imageNamed:@"defaulthead.png"]];
//    }
    self.avatarImage.image = imageModel.avatarImage;

    self.nameLabel.text = imageModel.name;

    if (imageModel.contentImage != nil) {
        self.contentImage.hidden = NO;
        self.contentImage.image = imageModel.contentImage;
    }
    else
    {
        self.contentImage.hidden = NO;
    }
    
    if (imageModel.content.length != 0) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = imageModel.content;
    } else {
        self.contentLabel.hidden = YES;
    }

    self.diggCountLabel.text = [NSString stringWithFormat:@"%@", imageModel.digg_count];
    self.buryCountLabel.text = [NSString stringWithFormat:@"%@", imageModel.bury_count];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", imageModel.comment_count];
}

- (void)nonClickBtn:(id)sender {
    
}

// 判断有无网络 0 有网络 1 无网络
- (BOOL) networkIsEnabled {
    BOOL bEnabled = FALSE;
    NSString *url = @"www.baidu.com";
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    SCNetworkReachabilityFlags flags;
    
    bEnabled = SCNetworkReachabilityGetFlags(ref, &flags);
    
    CFRelease(ref);
    if (bEnabled) {
        //        kSCNetworkReachabilityFlagsReachable：能够连接网络
        //        kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
        //        kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接，比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接。
        BOOL flagsReachable = ((flags & kSCNetworkFlagsReachable) != 0);
        BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
        BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
        bEnabled = ((flagsReachable && !connectionRequired) || nonWiFi) ? YES : NO;
    }

    return bEnabled;
}

- (BOOL)isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        return NO;
    }
    
    return isExistenceNetwork;
}

- (BOOL)reachabilityChanged:(NSNotification *)notification {
    Reachability *currentReach = [notification object];
    NetworkStatus netStatus = [currentReach currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
        {
            _netIsConnect = NO;
        }
            break;
        case ReachableViaWWAN:
        {
            _netIsConnect = YES;
        }
            break;
        case ReachableViaWiFi:
        {
            _netIsConnect = YES;
        }
            break;
        default:
            break;
    }
    
    return _netIsConnect;
}

- (IBAction)sharedButtonClick:(UIButton *)sender {
}


@end
