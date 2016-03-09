//
//  MusicPlayer.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/2.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "MusicPlayerSingLeton.h"

@implementation MusicPlayerSingLeton
@synthesize stream;

+ (MusicPlayerSingLeton *)stantdardMusicPlayer
{
    static MusicPlayerSingLeton *player;
    if (player==nil)
    {
        player = [[MusicPlayerSingLeton alloc]init];
    }
    
    return player;
}

- (id)init
{
    self  = [self init];
    @synchronized(self)
    {
        if (self)
        {
            stream = [[AudioStreamer alloc]init];
        }
    }
    return self;
}


- (void)startWithUrl:(NSURL *)url
{
    [stream startWithUrl:url];
}


- (void)stop
{
    [stream stop];
}


- (void)pause
{
    [stream pause];
}

@end
