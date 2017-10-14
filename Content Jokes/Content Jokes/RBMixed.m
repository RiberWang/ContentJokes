//
//  RBMixed.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-27.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBMixed.h"
#import "Reachability.h"

@implementation RBMixed

+ (CGSize)setLabelFrameAccordingTextContent:(NSString *)text andLabelWidth:(CGFloat)labelWidth andLabelFontSize:(CGFloat)size {
        CGRect rect = [text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
        return rect.size;
}

+ (CGRect)setButtonFrameWithLabelText:(NSString *)text andLabelWidth:(CGFloat)labelWidth andLabelFontSize:(CGFloat)size {
    //设置名字label和button的长度
    CGRect rect = [text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    rect.size.width = 30+10+rect.size.width;//加button自身的宽度和开始多出的部分
    return rect;
}

//获取当前设备版本
+ (double)getCurrentDeviceIOSVersion {
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

// 判断有网络没网络
+ (BOOL)isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.taobao.com"];
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

@end
