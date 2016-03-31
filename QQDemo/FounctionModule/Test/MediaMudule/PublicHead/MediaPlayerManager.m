//
//  MediaPlayerManager.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/2.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "MediaPlayerManager.h"

@implementation MediaPlayerManager
@synthesize targetController;

+ (MediaPlayerManager *)standardManage
{
    static MediaPlayerManager *manager;

    if (manager==nil) {
        manager = [[MediaPlayerManager alloc]init];
    }
    return manager;
}

- (void)playerMusicWithUrl:(NSURL *)url
{
    MusicPlayerSingLeton *player = [MusicPlayerSingLeton stantdardMusicPlayer];
    [player startWithUrl:url];
}

- (void)stopMusicPlayer
{
    MusicPlayerSingLeton *player = [MusicPlayerSingLeton stantdardMusicPlayer];
    [player stop];
}

- (void)playVideoWithUrl:(NSURL *)url Deleget:(id)deleget
{
    VideoPlayerStreamViewController *controller = [[VideoPlayerStreamViewController alloc]initWithUrl:url deleget:self];
    
    UIViewController *basicController  = (UIViewController *)targetController;
    
    [basicController.navigationController showViewController:controller sender:nil];
    
}

- (void)setTargetController:(id)_targetController
{

    if (targetController!=nil)
    {
        if (targetController!=_targetController)
        {
            targetController = nil;
            targetController = _targetController;
        }
    }
    else
    {
        targetController = _targetController;
    }
    
}

- (void)stopVideoPlayer
{

}

@end
