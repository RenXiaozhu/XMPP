//
//  VideoTool.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/20.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "VideoTool.h"
#import "PublicFile.h"

#import "VideoPlayerStreamViewController.h"

@implementation VideoTool
@synthesize progressLine;
@synthesize playProgressView;
@synthesize bgView;
@synthesize target;
@synthesize playButton;
@synthesize currentTimeLabel;

- (id)initWithFrame:(CGRect)frame deleget:(id)deleget
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        target = deleget;
        
        [self initUIWithFrame:frame];
        
    }
    return self;
}

- (void)initUIWithFrame:(CGRect)frame
{
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(10, 10, 30, 30);
    [playButton setBackgroundImage:[UIImage imageNamed:@"Btn_Play"] forState:UIControlStateNormal];
    [self addSubview:playButton];
    
    progressLine = [[UIProgressView alloc]initWithFrame:CGRectMake(playButton.frame.origin.x+playButton.frame.size.width+50, self.bounds.size.height/2-2, SCREEN_HEIGHT-playButton.frame.origin.x-playButton.frame.size.width-50-100, 4)];
    progressLine.progressViewStyle = UIProgressViewStyleBar;
    [progressLine setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.8f]];
    progressLine.alpha = 0.5f;
    [progressLine setProgressTintColor:[UIColor lightGrayColor]];
    [self addSubview:progressLine];
    
    bgView = [[FXBlurView alloc]initWithFrame:self.bounds];
    [bgView setTintColor:[UIColor clearColor]];
    bgView.alpha = 0.5f;
    bgView.dynamic = YES;
    bgView.blurRadius = 5;
    [self addSubview:bgView];
    
    playProgressView = [[JMPasswordLineLayer alloc]init];
    playProgressView.frame = CGRectMake( progressLine.frame.origin.x, 5, progressLine.frame.size.width, 40);
//    playProgressView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    playProgressView.nowPoint = CGPointMake(0, 20);
    playProgressView.processPoint = CGPointMake( 0, 20);
    [bgView.layer addSublayer:playProgressView];
    [playProgressView setNeedsDisplay];
    [playProgressView setNeedsLayout];
    
    currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(playProgressView.frame.origin.x+playProgressView.frame.size.width, 5, 100, 40)];
    currentTimeLabel.backgroundColor = [UIColor clearColor];
    currentTimeLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.font = [UIFont systemFontOfSize:14];
    currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:currentTimeLabel];
    
}


- (void)upDateProgressWithTime:(CGFloat)bufferProgress playTime:(CGFloat)playProgress timeString:(NSString *)timeaString
{
    [progressLine setProgress:bufferProgress animated:YES];
    VideoPlayerStreamViewController *control = (VideoPlayerStreamViewController *)target;

    CMTime  duration = [control.custmoPlayer.player.currentItem duration];
    CGFloat totalDuration = CMTimeGetSeconds(duration);
//    CGFloat scale = progressLine.frame.size.width/totalDuration;
    playProgressView.processPoint = CGPointMake((playProgress/totalDuration)*progressLine.frame.size.width, 20);
    
    DDLogInfo(@"nowTime == %f playProgress==%f  totalDuration==%f ", playProgress/totalDuration,playProgress,totalDuration);
    [playProgressView setNeedsDisplay];
    [playProgressView setNeedsLayout];
    
    currentTimeLabel.text = timeaString;
    
}

-(void)movieProgressDragged:(id)sender
{
    VideoPlayerStreamViewController *control = (VideoPlayerStreamViewController *)target;
    [control showLoadingWithState:Player_JumpToTime];
    
    SInt32 fort = control.custmoPlayer.player.currentTime.timescale;
    CMTime time = CMTimeMakeWithSeconds(progressLine.progress*control.totalMovieDuration, fort);
    [control.custmoPlayer.player seekToTime:time];
    
}


- (void)dealloc
{
    bgView  = nil;
    progressLine = nil;
    currentTimeLabel = nil;
    playProgressView = nil;
    target = nil;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
