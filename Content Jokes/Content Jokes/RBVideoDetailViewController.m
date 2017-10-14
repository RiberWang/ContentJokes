//
//  RBVideoDetailViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-2-1.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBVideoDetailViewController.h"

@interface RBVideoDetailViewController ()

@end

@implementation RBVideoDetailViewController

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
    self.url = [NSString stringWithFormat:CONTENT_DETAIL_PATH, self.videoModel.group_id, CONTENT_DETAIL_PATH_PART];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailCell *detailCell = (RBDetailCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        RBVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VIDEO"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RBVideoCell class]) owner:self options:nil] lastObject];
        }
        
        cell.playerView = [[RBPlayerView alloc] init];
        cell.playerView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:cell.playerView];
        [cell.contentView insertSubview:cell.playerView belowSubview:cell.playBtn];
        //显示第一个分区cell的信息
        [cell showInVideoCell:self.videoModel];
        
        if (self.videoModel.content.length != 0) {
            cell.contentLabel.hidden = NO;
            //设置发表的内容高度
            CGRect frame = cell.contentLabel.frame;
            frame.size.height = ceil(self.textLabelHeight);
            cell.contentLabel.frame = frame;
            //设置播放器视图的位置
            cell.playerView.frame = CGRectMake(20, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+10, 280, [self.videoModel.video_height floatValue]/2);
        } else {
            cell.contentLabel.hidden = YES;
            cell.playerView.frame = CGRectMake(20, cell.contentLabel.frame.origin.y, 280, [self.videoModel.video_height floatValue]/2);
        }
        
        [self setPlayerUrl:self.videoModel.mp4_url andVideoCell:cell];
        
        [cell.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        cell.playBtn.tag = indexPath.row;
        
        // 用户信息页
        // 设置点击进入用户页的按钮
        cell.userInfoButton.tag = [self.videoModel.user_id intValue];
        [cell.userInfoButton setTitle:self.videoModel.name forState:UIControlStateNormal];
        [cell.userInfoButton addTarget:self action:@selector(gotoUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return detailCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.videoModel.content.length == 0) {
            return 30+20+[self.videoModel.video_height intValue]/2+4*10;
        }
        return self.textLabelHeight+[self.videoModel.video_height floatValue]/2+15+20+6*10;
    }
    
    return height;
}

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
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidAppear:YES];
    RBVideoCell *videoCell = (RBVideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [videoCell.player pause];
}


@end
