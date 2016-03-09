//
//  ChatTextField.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/26.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"
#import "EmoticonView.h"

@interface ChatTextField : UIView<UITextViewDelegate>
{
    BOOL isRoomChat;
    EmoticonView *emoticonView;//表情view
    UIView *funcationModule;//文件传输、音视频等功能
    BOOL isShowEmoticonView;
    BOOL isShowFunctionView;
    UITextView *inputTextField;
}

@property (nonatomic,assign) BOOL isRoomChat;
@property (nonatomic,assign) BOOL isShowEmoticonView;
@property (nonatomic,assign) BOOL isShowFunctionView;
@property (nonatomic,retain) EmoticonView *emoticonView;
@property (nonatomic,retain) UITextView *inputTextField;
@property (nonatomic,retain) UIView *funcationModule;


- (instancetype)initWithFrame:(CGRect)frame isRoomChat:(BOOL)_isRoomChat;


@end
