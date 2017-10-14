//
//  RBImageDetailViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-31.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBImageDetailViewController.h"

@interface RBImageDetailViewController ()
@end

@implementation RBImageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUrl {
    self.url = [NSString stringWithFormat:CONTENT_DETAIL_PATH, self.imageModel.group_id, CONTENT_DETAIL_PATH_PART];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailCell *detailCell = (RBDetailCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        RBContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CONTENT"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBContentCell class]) owner:self options:nil] lastObject];
        }
        
        cell.netIsConnect = self.netIsAvaild;
        //显示第一个分区cell的信息
        [cell showInImageCell:self.imageModel];

        //contentLabel 20 50 280 30
        if (self.imageModel.content.length == 0) {
            cell.contentLabel.hidden = YES;
            cell.contentImage.frame = CGRectMake(cell.contentLabel.frame.origin.x, cell.contentLabel.frame.origin.y, [self.imageModel.width floatValue], [self.imageModel.height floatValue]);
        } else {
            cell.contentLabel.hidden = NO;
            
            //动态设置评论内容的大小
            //动态设置cell中控件的位置
            cell.contentLabel.frame = CGRectMake(cell.contentLabel.frame.origin.x, cell.contentLabel.frame.origin.y, cell.contentLabel.frame.size.width, self.textLabelHeight);
            
            cell.contentImage.frame = CGRectMake(cell.contentImage.frame.origin.x, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+10, [self.imageModel.width floatValue], [self.imageModel.height floatValue]);
        }
        
        //给图片添加手势
        [self addGesture:cell.contentImage];
        
        // 用户信息页
        // 点击进入用户详情页
        cell.userInfoButton.tag = [self.imageModel.user_id intValue];
        [cell.userInfoButton setTitle:self.imageModel.name forState:UIControlStateNormal];
        [cell.userInfoButton addTarget:self action:@selector(gotoUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return detailCell;
}

#pragma mark - 小图片添加手势 使其点击进入大图
//给点击的小图图片添加手势 在cell里调用
- (void)addGesture:(UIImageView *)imgView {
    imgView.tag = 10000;
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imgView addGestureRecognizer:tap];
}

#pragma mark - 进入大图模式
//点击小图图片进入滚动视图
- (void)tap:(UITapGestureRecognizer *)tap {
    // 获取点击的原图 小图片
    UIImageView *orginImageView = (UIImageView *)tap.view;
    
    //创建滚动视图 解决一个问题 多次点击还会进入大图 并且无法退出 解决办法:初始化背景图的时候和原图frame一样
    _scrollView = [[UIScrollView alloc] initWithFrame:orginImageView.frame];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(0, [self.imageModel.largeHeight floatValue]);
    _scrollView.alpha = 0;
    
    // 获取当前的window 将图片加到widow上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_scrollView];
    
    // 大图片大小和背景大小初始化的大小都设置为小图片的初始位置
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:orginImageView.frame];
    imageView.alpha = 0;
//    if (self.netIsAvaild) {
//        [imageView setImageWithURL:[NSURL URLWithString:self.imageModel.largeUrl]];
//    } else {
//        imageView.image = self.imageModel.contentLargeImage;
//    }
    if (self.imageModel.contentLargeImage == nil) {
        [imageView setImageWithURL:[NSURL URLWithString:self.imageModel.largeUrl]];
    }
    else
    {
        imageView.image = self.imageModel.contentLargeImage;
    }

    imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:imageView];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    // 点击大图片和背景都能返回小图片 解决一个问题 图片太小的话 点击黑色背景无法退出大图模式
    [imageView addGestureRecognizer:backTap];
    [_scrollView addGestureRecognizer:backTap];
    
    //点击小图时执行动画效果 进入大图
    [UIView animateWithDuration:0.5f animations:^{
        _scrollView.frame = CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height);
        _scrollView.alpha = 1;
        imageView.alpha = 1;
        if ([self.imageModel.largeHeight floatValue] <= _scrollView.frame.size.height) {
            imageView.frame = CGRectMake(0, (_scrollView.frame.size.height-[self.imageModel.largeHeight floatValue])/2, WINDOW_SIZE.width, [self.imageModel.largeHeight floatValue]);
        } else {
            imageView.frame = CGRectMake(0, 0, WINDOW_SIZE.width, [self.imageModel.largeHeight floatValue]);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _scrollView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

#pragma mark - 大图点击返回小图
// 点击的大图返回小图
- (void)goBack:(UITapGestureRecognizer *)backTap {
    [UIView animateWithDuration:0.5f animations:^{
        _scrollView.alpha = 0;
        backTap.view.alpha = 0;
        _scrollView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {

        // 1.解决多次点击图片 弹出多张图片 无法退出的问题 解决方法:在点击小图进入大图的时候让小图的点击设置不可用(图片的用户权限关闭) 当点击大图回到原来的视图的时候 让小图的点击设置可用(图片的用户权限打开) 这样就不会触发多次小图的点击事件了 还是存在问题 如果点击的速度快 小图片不能被点击
        // 2.这次解决了这个问题 不用设置图片的与用户权限的交互 初始化大图背景的时候 背景的frame要和小兔的frame相同这样就不会出现点击多次小图 弹出多张大图的情况了 另外还解决了一个未知的bug 图片如果过小 有黑色背景的时候 点击大图无法退出小图 解决方法:给背景也添加返回小图的方法
        for (UIView *view in _scrollView.subviews) {
            [view removeFromSuperview];
        }
        [_scrollView removeFromSuperview];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.textLabelHeight == 0) {
            return 20+15+10*5+[self.imageModel.height floatValue];
        }
        
        return self.textLabelHeight+[self.imageModel.height floatValue]+20+15+10*6; // 6个间隔 还有1个10是底部的10个间隔
    }
    
    return height;
}

@end
