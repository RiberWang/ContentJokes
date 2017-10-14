//
//  RBVideoViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBVideoViewController.h"
#import "RBVideoModel.h"
#import "RBVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import "RBPlayerView.h"
#import "RBVideoDetailViewController.h"

@interface RBVideoViewController ()

@end

// 模拟器该页面崩溃
@implementation RBVideoViewController

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
    
    [self setDownRefresh:YES];
    [self setUpRefresh:YES];
    [self setNavBarButton:YES];
    self.url = @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=18&level=6&message_cursor=-1&loc_mode=0&count=30&min_time=1421921618&iid=2539854662&device_id=3150072610&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=330&device_platform=android&device_type=HUAWEI%20U8825D&os_api=15&os_version=4.0.4&uuid=867247017609073&openudid=62e201d639b5a3";
    [self startRequest];
}

- (void)setUrl {
    NSTimeInterval min_time = [[NSDate date] timeIntervalSince1970];
    self.url = [NSString stringWithFormat:VIDEO_PATH, (int)min_time, VIDEO_PATH_PART];
}

- (void)titleButtonClick:(UIButton *)button {
    self.category_id = @"3";
    [super titleButtonClick:button];
}

//重写父类中的方法
- (void)endRequestWithData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *firstDataDic = dic[@"data"];
    for (NSDictionary *secondDic in firstDataDic[@"data"]) {
        NSDictionary *groupDic = secondDic[@"group"];
        if (groupDic) {
            RBVideoModel *videoModel = [[RBVideoModel alloc] init];
            [videoModel setValuesForKeysWithDictionary:groupDic];
            NSDictionary *userDic = groupDic[@"user"];
            [videoModel setValuesForKeysWithDictionary:userDic];
            
            [self dataSourcesAddModel:videoModel];
        }
    }
    
    [super endRequestWithData:data];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"VIDEO"];
    if (videoCell == nil) {
        videoCell = [RBVideoCell videoCell];
    }
    
    //[[videoCell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    NSArray *array = [videoCell.contentView subviews];
//    for (UIView *vc in array) {
//        if ([vc isKindOfClass:[RBPlayerView class]]) {
//            [vc removeFromSuperview];
//        }
//    }
    
    // 解决cell很乱
    [videoCell.player pause];
    [videoCell.playerView removeFromSuperview];
    
    videoCell.playerView = [[RBPlayerView alloc] init];
    videoCell.playerView.backgroundColor = RGB(193, 193, 193);
    [videoCell.contentView addSubview:videoCell.playerView];
    [videoCell.contentView insertSubview:videoCell.playerView belowSubview:videoCell.playBtn];
    
    RBVideoModel *videoModel = self.dataSources[indexPath.row];
    [videoCell showInVideoCell:videoModel];
    
    float width = [videoModel.video_width floatValue]/2;
    // 播放器的宽度 最大值为280
    if (width != 280) {
        width = 280;
    }
    
    if (videoModel.content.length != 0) {
        videoCell.contentLabel.hidden = NO;
        //设置发表的内容高度
        CGRect frame = videoCell.contentLabel.frame;
        frame.size.height = ceil([RBMixed setLabelFrameAccordingTextContent:videoModel.content andLabelWidth:280 andLabelFontSize:15].height);
        videoCell.contentLabel.frame = frame;
        //设置播放器视图的位置
        videoCell.playerView.frame = CGRectMake(20, videoCell.contentLabel.frame.origin.y+videoCell.contentLabel.frame.size.height+10, width, [videoModel.video_height floatValue]/2);
    } else {
        videoCell.contentLabel.hidden = YES;
        videoCell.playerView.frame = CGRectMake(20, videoCell.contentLabel.frame.origin.y, width, [videoModel.video_height floatValue]/2);
    }
    
    // 播放按钮位置
    //videoCell.playBtn.center = CGPointMake(CGRectGetWidth(videoCell.playerView.frame)/2.0+20, CGRectGetHeight(videoCell.playerView.frame)/2.0+videoCell.playerView.frame.origin.y);
    
    // 关联播放器
    [self setPlayerUrl:videoModel.mp4_url andVideoCell:videoCell];

    // 播放按钮的点击事件
    [videoCell.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    videoCell.playBtn.tag = indexPath.row;
    
    //设置button的长度
    CGRect rect = [RBMixed setButtonFrameWithLabelText:videoModel.name andLabelWidth:240 andLabelFontSize:17];
    videoCell.userInfoButton.frame = CGRectMake(videoCell.userInfoButton.frame.origin.x, videoCell.userInfoButton.frame.origin.y, rect.size.width, videoCell.userInfoButton.frame.size.height);
    //为button添加事件
    [videoCell.userInfoButton addTarget:self action:@selector(pushToUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
    videoCell.userInfoButton.tag = [videoModel.user_id intValue];
    [videoCell.userInfoButton setTitle:[NSString stringWithFormat:@"%@", videoModel.name] forState:UIControlStateNormal];
    
    return videoCell;
}

#pragma mark - 进入用户详情页
// 在父类中实现


- (void)play:(UIButton *)btn {
    RBVideoCell* videoCell = (RBVideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    
    [videoCell.player play];
    [videoCell.contentView sendSubviewToBack:videoCell.playBtn];
    videoCell.playCountAndTimebgView.hidden = YES;
}

//创建播放器 并关联屏幕
- (void)setPlayerUrl:(NSString *)playUrl andVideoCell:(RBVideoCell *)videoCell {
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:playUrl]];
    [asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        AVPlayerItem *_playerItem = [AVPlayerItem playerItemWithAsset:asset];
        videoCell.player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
        [videoCell.playerView setPlayer:videoCell.player];
        
        //设置进度条
        __weak RBVideoCell *video = videoCell;
        __weak UIProgressView *progress = videoCell.progressView;
        [video.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            //当前时间
            CMTime currentTime = video.player.currentItem.currentTime;
            CMTime duration = video.player.currentItem.duration;
            //总时间
            [progress setProgress:CMTimeGetSeconds(currentTime)/CMTimeGetSeconds(duration) animated:YES];
            
            if (CMTimeGetSeconds(currentTime) == CMTimeGetSeconds(duration)) {
                //播放结束后将播放按钮提到最前面
                [video.contentView bringSubviewToFront:video.playBtn];
                videoCell.playCountAndTimebgView.hidden = NO;
                //CMTime curFrame = CMTimeMake(第几帧， 帧率）
                [video.player seekToTime:CMTimeMakeWithSeconds(0, 10)];
            }
            else
            {
//                [video.contentView sendSubviewToBack:video.playBtn];
//                videoCell.playCountAndTimebgView.hidden = YES;
            }
        }];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBVideoModel *videoModel = self.dataSources[indexPath.row];
    
    if (videoModel.content.length == 0) {
        return [videoModel.video_height intValue]/2+15+20+5*10;
    }
    return ceil([RBMixed setLabelFrameAccordingTextContent:videoModel.content andLabelWidth:280 andLabelFontSize:15].height)+[videoModel.video_height floatValue]/2+15+20+6*10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBVideoModel *videoModel = self.dataSources[indexPath.row];
    
    RBVideoDetailViewController *detailVC = [[RBVideoDetailViewController alloc] init];
    detailVC.videoModel = videoModel;
    detailVC.textLabelHeight = ceil([RBMixed setLabelFrameAccordingTextContent:videoModel.content andLabelWidth:280 andLabelFontSize:15].height);
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
