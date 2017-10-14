//
//  PopoverView.h
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverView : UIView

// 初始化方法设置选中状态的图片和正常显示的图片
-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles normolImages:(NSArray *)normolImages andSelectImages:(NSArray *)selectImages;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);
@property (nonatomic, copy) void (^clickButton)(); // 自己添加的
@property(nonatomic, assign) NSInteger selectedRow;
@property(nonatomic, strong) UIButton *titleButton;

@end
