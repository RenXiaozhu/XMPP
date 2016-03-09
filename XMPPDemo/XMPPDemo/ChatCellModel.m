//
//  ChatCellModel.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/27.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "ChatCellModel.h"

@implementation ChatCellModel

@synthesize inputText  = _inputText;          //输入的文字

@synthesize userBgType = _userBgType;         //文字气泡背景类型

@synthesize modelJid   = _modelJid;

//@synthesize userId     = _userId;             //用户ID
//
//@synthesize userName   = _userName;           //用户昵称
//
//@synthesize userPhotoName = _userPhotoName;   //用户头像本地文件名

@synthesize state = _state;         //用户登陆状态


- (void)dealloc
{

    [_inputText release];
    [_userBgType release];
//    [_userId release];
//    [_userName release];
//    [_userPhotoName release];
    [super dealloc];
    
}

@end
