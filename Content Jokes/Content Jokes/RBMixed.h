//
//  RBMixed.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-27.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBJokeCell.h"

@interface RBMixed : NSObject

//图文混排类
+ (CGSize)setLabelFrameAccordingTextContent:(NSString *)text andLabelWidth:(CGFloat)labelWidth andLabelFontSize:(CGFloat)size;

//动态设置button的宽度
+ (CGRect)setButtonFrameWithLabelText:(NSString *)text andLabelWidth:(CGFloat)labelWidth andLabelFontSize:(CGFloat)size;

+ (BOOL)isConnectionAvailable;

@end
