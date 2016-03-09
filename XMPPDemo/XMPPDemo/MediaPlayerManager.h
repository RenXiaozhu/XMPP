//
//  MediaPlayerManager.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/2.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicPlayerSingLeton.h"
#import "VideoPlayerStreamViewController.h"
@interface MediaPlayerManager : NSObject
{
    id targetController;
}
@property (nonatomic,retain) id targetController;

+ (MediaPlayerManager *)standardManage;

- (void)setTargetController:(id)_targetController;

- (void)playerMusicWithUrl:(NSURL *)url;

- (void)stopMusicPlayer;

- (void)playVideoWithUrl:(NSURL *)url Deleget:(id)deleget;

- (void)stopVideoPlayer;

@end
