//
//  CustomView.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/3.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>



@interface CustomView : UIView
{
    AVPlayer *player;
}

@property(nonatomic,retain) AVPlayer *player;

@end
