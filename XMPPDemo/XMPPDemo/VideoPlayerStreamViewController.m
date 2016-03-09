//
//  VideoPlayerStreamViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/2.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "VideoPlayerStreamViewController.h"
#import "UINavigationBar+Awesome.h"

#define STRINGSTATUS( status)  [NSString stringWithFormat:@"%d",status]

typedef enum
{
    activityTag = 5,
    tipLableTag,
    rePlaybtnTag,
    firstPlayTag,
    loadingErrorRePlayTag,
    RePlayTag
}ViewTag;

@interface VideoPlayerStreamViewController ()
{
    UIImageView *_bgView;
    CGPoint _prePoint;
    CGPoint _curPoint;
    UIView *_controlView;
    BOOL _isAppear;
    
}

-(void)initPlayer;
-(void)monitorMovieProgress;
-(NSString*)convertMovieTimeToText:(CGFloat)time;
-(void)initMoviewPreview;
-(CustomView*)previewViewCreate:(CGFloat)xOffsetInSlider;
@end

@implementation VideoPlayerStreamViewController
@synthesize deleget;
@synthesize isOnLine;
@synthesize moviePlayer;
@synthesize movieURL;
@synthesize custmoPlayer;
@synthesize state;
@synthesize currentTime;
@synthesize startTime;
@synthesize totalMovieDuration;
@synthesize toolView;
@synthesize movieProgressSlider;
@synthesize totalTimeLabel;
@synthesize playbackTimeObserver=_playbackTimeObserver;

- (id)initWithUrl:(NSURL *)url deleget:(id)aDeleget
{
    self = [super init];
    if (self) {
        deleget =[aDeleget retain];
        isOnLine = YES;
        movieURL = [url retain];
    }
    return self;
}


- (id)initWithContenturl:(NSURL *)url deleget:(id)aDeleget
{
    self = [super init];
    if (self) {
        movieURL = [url retain];
        deleget =[aDeleget retain];
        isOnLine = NO;
        
    }
    return self;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        if (custmoPlayer.player.currentItem.status == AVPlayerItemStatusReadyToPlay)
        {
            [custmoPlayer.player play];
            CMTime duration = custmoPlayer.player.currentItem.duration;// 获取视频总长度
            CGFloat totalSecond = duration.value /duration.timescale;// 转换成秒
            totalTimeLabel.text = [self convertMovieTimeToText:totalSecond];
            [self showLoadingWithState:Player_prePareToPlay];
        }
        else if (custmoPlayer.player.currentItem.status == AVPlayerItemStatusFailed)
        {
            NSLog(@" AVPlayerItemStatusFailed  error ~~ %@",[custmoPlayer.player.currentItem error]);
            [self showLoadingWithState:Player_PlayerError];
        }
        else
        {
        
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
//        [self monitorMovieProgress];
    }
    else if ([keyPath isEqualToString:@"currentTime"])
    {
        [self monitorMovieProgress];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [custmoPlayer.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [custmoPlayer.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter]removeObserver:self  name:AVPlayerItemNewAccessLogEntryNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self                                                 name:AVPlayerItemNewErrorLogEntryNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self                                                 name:AVPlayerItemFailedToPlayToEndTimeErrorKey
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self                                                 name:AVPlayerItemTimeJumpedNotification
                                               object:custmoPlayer.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self                                                 name:@"AVPlayerItemStatusReadyToPlay"
                                               object:custmoPlayer.player.currentItem];
    
    [custmoPlayer.player replaceCurrentItemWithPlayerItem:nil];
    [self.navigationController.navigationBar lt_reset];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self playItemWithType:firstPlayTag];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [self.navigationController.navigationBar lt_setContentAlpha:0.2f];
    
    if (self.interfaceOrientation!= UIInterfaceOrientationLandscapeRight) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationLandscapeRight];
            [UIViewController attemptRotationToDeviceOrientation];
        }
    }
    
}

- (void)correctFrame
{
    
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
    {
//        [UIView animateWithDuration:0.3f animations:^{
//            custmoPlayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//            custmoPlayer.transform = CGAffineTransformRotate(custmoPlayer.transform, M_PI_2);
            _bgView.frame      = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//            _bgView.transform = CGAffineTransformRotate(_bgView.transform, M_PI_2);
//            toolView.frame = CGRectMake(0, self.view.bounds.size.width-60, self.view.bounds.size.height, 60);
//            toolView.transform = CGAffineTransformRotate(toolView.transform, M_PI_2);
//            
////            loadingView.transform = CGAffineTransformRotate(loadingView.transform, M_PI_2);
//            loadingView.frame = CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height/2-50, 100, 100);
//            loadingView.center = toolView.center;
//        }];
    }
    else if ([[UIDevice currentDevice] orientation] ==UIInterfaceOrientationPortrait)
    {
        if (self.view.bounds.size.height>self.view.bounds.size.width) {
//            [UIView animateWithDuration:0.3f animations:^{
//                custmoPlayer.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
//                custmoPlayer.transform = CGAffineTransformRotate(custmoPlayer.transform, M_PI_2);
                _bgView.frame      = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
//                _bgView.transform = CGAffineTransformRotate(_bgView.transform, M_PI_2);
//                toolView.transform = CGAffineTransformRotate(toolView.transform, M_PI_2);
//                toolView.frame =  CGRectMake(0, self.view.bounds.size.height-60, self.view.bounds.size.width, 60);
//                loadingView.frame = CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height/2-50, 100, 100);

//            }];
        }
        else
        {
//            [UIView animateWithDuration:0.3f animations:^{
//                custmoPlayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//                custmoPlayer.transform = CGAffineTransformRotate(custmoPlayer.transform, M_PI_2);
                _bgView.frame      = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//                _bgView.transform = CGAffineTransformRotate(_bgView.transform, M_PI_2);
//                toolView.transform = CGAffineTransformRotate(toolView.transform, M_PI_2);
//                toolView.transform = CGAffineTransformRotate(toolView.transform, M_PI_2);
//                toolView.frame =  CGRectMake(0, self.view.bounds.size.width-60, self.view.bounds.size.height,60);
//                loadingView.frame = CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height/2-50, 100, 100);
//                loadingView.transform = CGAffineTransformRotate(loadingView.transform, M_PI_2);
//            }];
            
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
    _bgView.image = [UIImage imageNamed:@"VideoBg"];
    [self.view addSubview:_bgView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    
    if (isOnLine)
    {
        [self initPlayer];
    }
    else
    {
        [self initMPPlayer];
    }
    
    [self initToolView];
    
    // Do any additional setup after loading the view.
}

- (void)initLoadingView:(UIView *)view
{

    loadingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.height/2-50, self.view.bounds.size.width/2-50, 100, 100)];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.alpha = 0.5f;
    loadingView.layer.masksToBounds =YES;
    loadingView.layer.cornerRadius = 4;
    [view addSubview:loadingView];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.frame=CGRectMake(loadingView.frame.size.width/2-15, loadingView.frame.size.height/2-15, 30, 30);
    activity.tag = activityTag;
    [loadingView addSubview:activity];
    [activity release];
    
    UILabel *tipLable = [[UILabel alloc]init];
    tipLable.frame    = CGRectMake( 0 , loadingView.bounds.size.height-40,loadingView.bounds.size.width, 30);
    tipLable.backgroundColor = [UIColor clearColor];
//    tipLable.alpha = 0.8;
    tipLable.tag   = tipLableTag;
    tipLable.font  = [UIFont systemFontOfSize:14];
    tipLable.textColor = [UIColor whiteColor];
    tipLable.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:tipLable];
    [tipLable release];
    
    UIButton *rePlaybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rePlaybtn.frame  = CGRectMake( loadingView.frame.size.width/2-15, loadingView.frame.size.width/2-20, 40, 40);
    [rePlaybtn setTitle:@"重播" forState:UIControlStateNormal];
    [rePlaybtn setBackgroundImage:[UIImage imageNamed:@"refreshBtn"] forState:UIControlStateNormal];
    rePlaybtn.tag = rePlaybtnTag;
    [rePlaybtn addTarget:self action:@selector(rePlay:) forControlEvents:UIControlEventTouchUpInside];
    [loadingView addSubview:rePlaybtn];
    [rePlaybtn setHidden:YES];
    
    [loadingView setHidden:YES];
}


- (void)showLoadingWithState:(VideoState)VideoState
{
    /*
     Player_Initialized = 9,//视频初始化
     Player_prePareToPlay,  //初始化完成，准备播放
     Player_Playering,      //播放中
     Player_Pauseing,       //暂停
     Player_Finished,       //播放完成
     player_Close,          //关闭播放器
     Player_Buffering,      //视频缓冲中
     */
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[loadingView viewWithTag:activityTag];
    UIButton *rePlaybtn = (UIButton *)[loadingView viewWithTag:rePlaybtnTag];
    [rePlaybtn setHidden:YES];
//    UILabel *tipLabel = (UILabel *)[loadingView viewWithTag:tipLableTag];
    
    
   state = VideoState;
    switch (VideoState)
    {
        case Player_Initialized:
        {
            [loadingView setHidden:NO];
            [activity startAnimating];
        }
            break;
        case Player_prePareToPlay:
        {
            [loadingView setHidden:YES];
            [activity stopAnimating];
            [custmoPlayer.player play];
        }
            break;
        case Player_Playering:
        {
            
        }
            break;
        case Player_Pauseing:
        {
            [loadingView setHidden:NO];
            [activity stopAnimating];
            [custmoPlayer.player pause];
            [toolView.playButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
        }
            break;
        case Player_Finished:
        {
            [activity stopAnimating];
            [loadingView setHidden:NO];
            [rePlaybtn setHidden:NO];
            [rePlaybtn setTitle:@"重播" forState:UIControlStateNormal];
            [rePlaybtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
            break;
        case player_Close:
        {
            
        }
            break;
        case Player_Buffering:
        {
            [activity startAnimating];
            [loadingView setHidden:NO];
            
        }
            break;
        case Player_PlayerBack:
        {
            [activity stopAnimating];
            [loadingView setHidden:NO];
            [rePlaybtn setHidden:NO];
            [rePlaybtn setTitle:@"重播" forState:UIControlStateNormal];
            [rePlaybtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
            break;
        case Player_JumpToTime:
        {
            if (CMTimeGetSeconds(custmoPlayer.player.currentTime)!=0.000000)
            {
                if (toolView.progressLine.progress*totalMovieDuration>[self availableDuration])
                {
                    [activity startAnimating];
                    [activity setHidden:NO];
                    [loadingView setHidden:NO];
//                    [tipLabel setHidden:NO];
//                    tipLabel.text = [NSString stringWithFormat:@"%fs",progressLine.progress*totalMovieDuration];
                }
                else
                {
                    [activity stopAnimating];
                    [activity setHidden:YES];
                    [loadingView setHidden:YES];
                }
                
            }

        }
            break;
        case Player_LoadEror:
        {
            [activity stopAnimating];
            [loadingView setHidden:NO];
            [rePlaybtn setHidden:NO];
            [rePlaybtn setTitle:@"加载失败，重试" forState:UIControlStateNormal];
            [rePlaybtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
            break;
        case Player_PlayerError:
        {
            [activity stopAnimating];
            [loadingView setHidden:NO];
            [rePlaybtn setHidden:NO];
            [rePlaybtn setTitle:@"播放错误" forState:UIControlStateNormal];
            [rePlaybtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
   
    
}

- (void)rePlay:(UIButton *)btn
{
    
    if ([btn.titleLabel.text isEqualToString:@"重播"])
    {
        [self playItemWithType:RePlayTag];
    }
    else if ([btn.titleLabel.text isEqualToString:@"加载失败，重试"])
    {
        [self playItemWithType:loadingErrorRePlayTag];
    }
    
}


- (void)initToolView
{
 
    _controlView = [[UIView alloc]init];
    _controlView.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    _controlView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_controlView];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTool)];
    tap.numberOfTapsRequired = 1;
    [_controlView addGestureRecognizer:tap];
    
    toolView  = [[VideoTool alloc]initWithFrame:CGRectMake( 0, _controlView.frame.size.height-50, _controlView.frame.size.width, 50) deleget:self];
    [_controlView addSubview:toolView];

    [self initLoadingView:_controlView];
    
}


- (void)showTool
{

    if (_isAppear)
    {
        [self HiddenTool];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            toolView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
            _isAppear = YES;
            
        } completion:^(BOOL finished){
            [self performSelector:@selector(HiddenTool) withObject:nil afterDelay:5.0];
        }];
    }
    
}


- (void)HiddenTool
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.navigationController.navigationBar setFrame:CGRectMake(0, -44, SCREEN_WIDTH, 44)];
        toolView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
    }];
    _isAppear = NO;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point= [touch locationInView:_controlView];
    if (point.y>100&&point.y<SCREEN_HEIGHT-100)
    {
        _prePoint = point;
    }
    else
    {
        return;
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:_controlView];
    
    if (point.y>100&&point.y<SCREEN_HEIGHT-100)
    {
        _curPoint = point;
    }
    else
    {
        return;
    }
    
    if (_curPoint.x-_prePoint.x>20.0f||_curPoint.x-_prePoint.x<-20.0f)
    {
        CGFloat value = (_curPoint.x-_prePoint.x)/SCREEN_WIDTH/2.0f;
        
        [self acceptVolumeWithValue:value];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
}


- (void)acceptVolumeWithValue:(CGFloat)value
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    // retrieve system volume
    float systemVolume = volumeViewSlider.value;
    systemVolume = systemVolume+value;
    [volumeViewSlider setValue:systemVolume animated:YES];
    
    // send UI control event to make the change effect right now.
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    //                prePoint = curPoint;
    
    NSArray *audioTracks = [custmoPlayer.player.currentItem.asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioParams = [NSMutableArray array];
    
    for (AVAssetTrack *track in audioTracks) {
        
        AVMutableAudioMixInputParameters *audioInputParams =
        
        [AVMutableAudioMixInputParameters audioMixInputParameters];
        
        [audioInputParams setVolume:systemVolume atTime:kCMTimeZero];
        
        [audioInputParams setTrackID:[track trackID]];
        
        [allAudioParams addObject:audioInputParams];
        
    }
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    
    [custmoPlayer.player.currentItem setAudioMix:audioMix];
}


- (void)changeLoadViewDate:(NSNotification *)notfication
{
    
    
    NSString *notName = [notfication name];

    if ([notName isEqualToString:@"AVPlayerItemTimeJumpedNotification"])
    {
        CLog(@"---%f",CMTimeGetSeconds(custmoPlayer.player.currentTime) );
        [self showLoadingWithState:Player_JumpToTime];
    }
    else if ([notName isEqualToString:@"AVPlayerItemDidPlayToEndTimeNotification"])
    {
        [self showLoadingWithState:Player_Finished];
    }
    else if ([notName isEqualToString:@"AVPlayerItemFailedToPlayToEndTimeNotification"])
    {
        [self showLoadingWithState:Player_PlayerError];
    }
    else if ([notName isEqualToString:@"AVPlayerItemPlaybackStalledNotification"])
    {
        [self showLoadingWithState:Player_PlayerBack];
    }
    else if ([notName isEqualToString:@"AVPlayerItemNewAccessLogEntryNotification"])
    {
        CLog(@"AVPlayerItemNewAccessLogEntryNotification");
    }
    else if ([notName isEqualToString:@"AVPlayerItemNewErrorLogEntryNotification"])
    {
        CLog(@"AVPlayerItemNewErrorLogEntryNotification");
    }
    else if ([notName isEqualToString:@"AVPlayerItemFailedToPlayToEndTimeErrorKey"])
    {
        [self showLoadingWithState:Player_PlayerError];
    }
    else if ([notName isEqualToString:@"AVPlayerItemStatusReadyToPlay"])
    {
        [self showLoadingWithState:Player_prePareToPlay];
    }
    else if ([notName isEqualToString:@"AVPlayerItemNewAccessLogEntry"])
    {
        CLog(@"AVPlayerItemNewAccessLogEntry");
    }
    
}

- (void)initMPPlayer
{
    
}

- (void)initCustomView
{
    custmoPlayer = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    [self.view addSubview:custmoPlayer];
    custmoPlayer.backgroundColor = [UIColor clearColor];
    //    custmoPlayer.alpha = 0.8;
    AVPlayerLayer *layer = (AVPlayerLayer *)custmoPlayer.layer;
    layer.videoGravity   = AVLayerVideoGravityResizeAspect;
    
    //添加视频播放完成的notifation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadViewDate:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadViewDate:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadViewDate:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadViewDate:)
                                                 name:AVPlayerItemNewAccessLogEntryNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadViewDate:)
                                                 name:AVPlayerItemNewErrorLogEntryNotification
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadViewDate:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeErrorKey
                                               object:custmoPlayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadViewDate:)
                                                 name:AVPlayerItemTimeJumpedNotification
                                               object:custmoPlayer.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadViewDate:)
                                                 name:@"AVPlayerItemStatusReadyToPlay"
                                               object:custmoPlayer.player.currentItem];
    
        
}


- (void)playItemWithType:(NSInteger)type
{
    if (movieURL)
    {
        switch (type)
        {
            case firstPlayTag://首次播放
            {
                AVAsset *aset=[AVAsset assetWithURL:movieURL];
                AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:aset];
                AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
                [custmoPlayer setPlayer:player];
                [custmoPlayer.player play];
                
                CMTime total = item.duration;
                //检测视频加载状态，加载完成隐藏loadingView
                
                [self acceptVolumeWithValue:0.0];
                
                totalMovieDuration = CMTimeGetSeconds(total);
                
                [self monitoringPlayback:item];
                
                [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
                [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
                
            }
                break;
            case loadingErrorRePlayTag://重新加载
            {
                [self showLoadingWithState:Player_Buffering];
                CMTime time = custmoPlayer.player.currentItem.currentTime;
                [custmoPlayer.player pause];
                [custmoPlayer.player.currentItem seekToTime:time];
                [custmoPlayer.player play];
            }
                break;
            case RePlayTag://重播
            {
                [self showLoadingWithState:Player_Buffering];
                [custmoPlayer.player.currentItem seekToTime:kCMTimeZero];
                [custmoPlayer.player play];
            }
                break;
                
            default:
                break;
        }

    }
    
}

- (void)initPlayer
{
    [self showLoadingWithState:Player_Initialized];
    [self initCustomView];
}

-(void)doneClick:(id)sender
{
    
}

-(void)playClick:(id)sender
{
    [custmoPlayer.player play];
}



- (void)pause
{
    [custmoPlayer.player pause];
}

- (void)stop
{

}


- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
//    [custmoPlayer.player removeTimeObserver:self.playbackTimeObserver];
    self.playbackTimeObserver = [self.custmoPlayer.player addPeriodicTimeObserverForInterval:CMTimeMake( 1, self.custmoPlayer.player.currentTime.timescale) queue:NULL usingBlock:^(CMTime time) {
        
        [self monitorMovieProgress];
        
    }];
}

- (void)monitorMovieProgress
{
    NSTimeInterval timeInterVal = [self availableDuration];
    NSLog(@"time interval :%f",timeInterVal);
    CMTime  duration = [custmoPlayer.player.currentItem duration];
    CGFloat totalDuration = CMTimeGetSeconds(duration);

    CGFloat currentSecond = custmoPlayer.player.currentTime.value/custmoPlayer.player.currentTime.timescale;// 计算当前在第几秒
    NSString *timeString =[NSString stringWithFormat:@"%@/%@",[self convertMovieTimeToText:currentSecond],[self convertMovieTimeToText:totalDuration]];
    [toolView upDateProgressWithTime:(timeInterVal/totalDuration) playTime:currentSecond timeString:timeString];
    
    if (totalDuration-currentSecond<1)
    {
        [self performSelector:@selector(upDateProgress) withObject:nil afterDelay:1.0];
    }
    if (((timeInterVal-3)>=currentSecond)||(timeInterVal==totalDuration))
    {
        [custmoPlayer.player play];
    }
    else
    {
        [custmoPlayer.player pause];
        [self showLoadingWithState:Player_Buffering];
    }
}

- (void)upDateProgress
{
    NSTimeInterval timeInterVal = [self availableDuration];
    NSLog(@"time interval :%f",timeInterVal);
    CMTime  duration = [custmoPlayer.player.currentItem duration];
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    
    CGFloat currentSecond = custmoPlayer.player.currentTime.value/custmoPlayer.player.currentTime.timescale;// 计算当前在第几秒
    NSString *timeString =[NSString stringWithFormat:@"%@/%@",[self convertMovieTimeToText:currentSecond],[self convertMovieTimeToText:totalDuration]];
    [toolView upDateProgressWithTime:(timeInterVal/totalDuration) playTime:totalDuration timeString:timeString];
}

- (void)initMoviewPreview
{
    
}


- (NSString *)convertMovieTimeToText:(CGFloat)time
{
    int seconds = (int)time%60;
    int mins    = (int)(time/60)%60;
    return [NSString stringWithFormat:@"%02d:%02d",mins,seconds];
}


//- (CustomView *)previewViewCreate:(CGFloat)xOffsetInSlider
//{
//    
//}

- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [custmoPlayer.player.currentItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds+durationSeconds;//计算缓冲进度
    
    return result;
}

- (void)removeView
{
    [deleget release];
    if (custmoPlayer) {
        [self pause];
        [custmoPlayer removeFromSuperview];
        [toolView removeFromSuperview];
        [_bgView removeFromSuperview];
        
    }
    if (moviePlayer) {
        [moviePlayer stop];
//        [moviePlayer release];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation==UIInterfaceOrientationLandscapeRight;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self correctFrame];
    CLog(@"%@",[NSDate date]);
}


- (void)dealloc
{
    [custmoPlayer release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
