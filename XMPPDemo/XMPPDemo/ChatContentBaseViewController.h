//
//  ChatContentBaseViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/22.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma 文件传输协议
#import "TURNSocket.h"

#import "EmoticonView.h"
#import "ChatTextField.h"

@interface ChatContentBaseViewController : UIViewController<UITextViewDelegate,TURNSocketDelegate,UITextFieldDelegate>
{
    UITextView *inputTextView;
    UIButton *postBtn;
    UILabel *textLabel;
    TURNSocket *turnSocket;
    EmoticonView *emotconView;
    
    ChatTextField *chatInputTextView;
}
@property (nonatomic,retain) UITextView *inputTextView;
@property (nonatomic,retain) UIButton *postBtn;
@property (nonatomic,retain) UILabel *textLabel;
@property (nonatomic,retain) TURNSocket *turnSocket;
@property (nonatomic,retain) EmoticonView *emotconView;
@property (nonatomic,retain) ChatTextField *chatInputTextView;
@end
