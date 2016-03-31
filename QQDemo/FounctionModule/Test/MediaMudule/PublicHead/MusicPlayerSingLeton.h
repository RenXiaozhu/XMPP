//
//  MusicPlayer.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/2.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioStreamer.h"
@interface MusicPlayerSingLeton : NSObject
{
    AudioStreamer *stream;
}
@property (nonatomic,retain) AudioStreamer *stream;

+ (MusicPlayerSingLeton *)stantdardMusicPlayer;

- (void)startWithUrl:(NSURL *)url;
- (void)stop;
- (void)pause;

@end
