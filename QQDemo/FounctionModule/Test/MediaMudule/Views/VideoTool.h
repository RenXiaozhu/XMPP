//
//  VideoTool.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/20.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "JMPasswordLineLayer.h"
@interface VideoTool : UIView
{
    FXBlurView *bgView;
    UIProgressView *progressLine;//缓存进度
    JMPasswordLineLayer *playProgressView;//播放进度
    id target;
    UIButton *playButton;
    UILabel *currentTimeLabel;
}
@property (nonatomic,retain) FXBlurView *bgView;
@property (nonatomic,retain) UIProgressView *progressLine;
@property (nonatomic,retain) JMPasswordLineLayer*playProgressView;
@property (nonatomic,retain) id target;
@property (nonatomic,retain) UIButton *playButton;
@property (nonatomic,retain) UILabel *currentTimeLabel;

- (id)initWithFrame:(CGRect)frame deleget:(id)deleget;

- (void)upDateProgressWithTime:(CGFloat)bufferProgress playTime:(CGFloat)playProgress timeString:(NSString *)timeaString;

@end
