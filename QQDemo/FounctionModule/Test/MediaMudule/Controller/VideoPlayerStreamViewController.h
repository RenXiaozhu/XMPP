//
//  VideoPlayerStreamViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/2.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CustomView.h"
#import "PublicFile.h"
#import "VideoTool.h"

typedef NSData *(^requestData_File)(NSString *newId);

@interface VideoPlayerStreamViewController : UIViewController<UIPopoverControllerDelegate>
{
    id deleget;
    BOOL isOnLine;
    
    CustomView *custmoPlayer;//在线播放器
    MPMoviePlayerController *moviePlayer;
    
    //下部工具栏  
    VideoTool *toolView;
    UISlider *movieProgressSlider;
    
    
    //视频的总时间
    CGFloat totalMovieDuration;
    CGFloat startTime;
    CGFloat currentTime;
    
    
    UILabel *totalTimeLabel;
    UIView *loadingView;
    NSURL *movieURL;
    VideoState state;
}

@property (nonatomic,assign) CGFloat startTime;
@property (nonatomic,assign) CGFloat currentTime;
@property (nonatomic,assign) CGFloat totalMovieDuration;
@property (nonatomic,retain) NSURL *movieURL;
@property (nonatomic,retain) id deleget;
@property (nonatomic,assign) BOOL isOnLine;
@property (nonatomic,retain) CustomView *custmoPlayer;
@property (nonatomic,retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic,assign) VideoState state;
@property (nonatomic,retain) UISlider *movieProgressSlider;
@property (nonatomic,retain) VideoTool *toolView;

@property (nonatomic,retain) UILabel *totalTimeLabel;
@property (nonatomic,retain) id playbackTimeObserver;
- (id)initWithUrl:(NSURL *)url deleget:(id)aDeleget;//在线播放  playOnline
- (id)initWithContenturl:(NSURL *)url deleget:(id)aDeleget;
-(void)doneClick:(id)sender;
-(void)playClick:(id)sender;
-(void)movieProgressDragged:(id)sender;
- (void)pause;
- (void)stop;
- (void)showLoadingWithState:(VideoState)VideoState;

@end
