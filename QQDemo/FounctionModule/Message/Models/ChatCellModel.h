//
//  ChatCellModel.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/27.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicFile.h"
#import "XMPPJID.h"

@interface ChatCellModel : NSObject

@property (nonatomic,retain) NSString *inputText;   //输入的文字

@property (nonatomic,retain) NSString *userBgType;  //文字气泡背景类型

@property (nonatomic,retain) NSString *relation;    //好友关系

@property (nonatomic,retain) XMPPJID *modelJid;     //用户jid

@property (nonatomic,assign) LoginState state;      //登陆状态

@property (nonatomic,assign) MessageType type;

@end
