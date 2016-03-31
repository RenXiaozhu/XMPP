//
//  PublicFile.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/30.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPManager.h"

#define SCALINGSPEED     0.8
#define LEFTSCALING      0.7//左边菜单栏向右滑动缩放比例
#define RIGHTSCALING     0.7//右边菜单栏向左滑动缩放比例
#define HEIGHTSLOPE      600//高度缩放比例
#define MAINVIEWSCALING  0.8//主菜单缩放比例
#define SCREENSCALE          (SCREEN_WIDTH/SCREEN_HEIGHT)

typedef enum
{
    LogOut = 0,//离线
    logIn,     //在线
    goAway,    //离开
    cloaking   //隐身
    
}LoginState;


typedef enum
{
    TextType = 4,//文字类型
    MusicType,   //音频类型
    ViedoType,   //视频类型
    FileType,    //文件类型
    PictureType  //图片类型
    
}ShareType;


typedef enum
{
    Player_Initialized = 9,//视频初始化
    Player_prePareToPlay,  //初始化完成，准备播放
    Player_Playering,      //播放中
    Player_Pauseing,       //暂停
    Player_Finished,       //播放完成
    player_Close,          //关闭播放器
    Player_Buffering,      //视频缓冲中
    Player_PlayerBack,     //快退
    Player_JumpToTime,     //快进
    Player_PlayerError,    //播放错误
    Player_LoadEror        //加载失败
    
}VideoState;

typedef enum
{
    PLAYER_NO_STOP = 0,
    PLAYER_STOPPING_EOF,
    PLAYER_STOPPING_USER_ACTION,
    PLAYER_STOPPING_ERROR,
    PLAYER_STOPPING_TEMPORARILY
} VideoStreamerStopReason;

typedef enum
{
    PLAYER_NO_ERROR = 0,
    PLAYER_NETWORK_CONNECTION_FAILED,
    PLAYER_FILE_STREAM_GET_PROPERTY_FAILED,
    PLAYER_FILE_STREAM_SET_PROPERTY_FAILED,
    PLAYER_FILE_STREAM_SEEK_FAILED,
    PLAYER_FILE_STREAM_PARSE_BYTES_FAILED,
    PLAYER_FILE_STREAM_OPEN_FAILED,
    PLAYER_FILE_STREAM_CLOSE_FAILED,
    PLAYER_DATA_NOT_FOUND,
    PLAYER_QUEUE_CREATION_FAILED,
    PLAYER_QUEUE_BUFFER_ALLOCATION_FAILED,
    PLAYER_QUEUE_ENQUEUE_FAILED,
    PLAYER_QUEUE_ADD_LISTENER_FAILED,
    PLAYER_QUEUE_REMOVE_LISTENER_FAILED,
    PLAYER_QUEUE_START_FAILED,
    PLAYER_QUEUE_PAUSE_FAILED,
    PLAYER_QUEUE_BUFFER_MISMATCH,
    PLAYER_QUEUE_DISPOSE_FAILED,
    PLAYER_QUEUE_STOP_FAILED,
    PLAYER_QUEUE_FLUSH_FAILED,
    PLAYER_STREAMER_FAILED,
    PLAYER_GET_VIDEO_TIME_FAILED,
    PLAYER_BUFFER_TOO_SMALL
} VideoStreamerErrorCode;



typedef enum
{
    SelfPushMessage,
    AcceptFromOtherJid,
    AcceptFromRoom
    
}MessageType;


typedef enum
{
    NSLoadingViewNomalState,
    NSLoadingViewDragingState,
    NSLoadingViewDragingMaxState,
    NSLoadingViewInLoadingDataState,
    NSLoadingViewFinishedLoadDataState,
    NSLoadingViewErrorLoadDataState
    
}LoadingState;


typedef enum
{
    /*

     */

    RXZXMPPStream,
    /*
     XMPPStream：xmpp基础服务类
     //xmpp数据流
     stream = [[XMPPStream alloc] init];
     stream.enableBackgroundingOnSocket = YES;//允许后台socket运行
     [stream setHostName:HOST];
     [stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    */
    
    
    RXZXMPPRoster,
    /*
      XMPPRoster：好友列表类
     //花名册本地化
     XMPPRosterCoreDataStorage* storage = [[XMPPRosterCoreDataStorage alloc] init];
     _roster = [[XMPPRoster alloc] initWithRosterStorage:storage];
     _roster.autoAcceptKnownPresenceSubscriptionRequests = YES;//自动接受认证请求
     _roster.autoFetchRoster = YES;//自动获取好友列表
     [_roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
     [_roster activate:stream];
     [storage release];
     */
    
    
    RXZXMPPRosterCoreDataStorage,
    /*
      XMPPRosterCoreDataStorage：好友列表（用户账号）在core data中的操作类
     XMPPRosterCoreDataStorage* storage = [[XMPPRosterCoreDataStorage alloc] init];
     
     */
    
    
    RXZXMPPvCardCoreDataStorage,
    /*
     XMPPvCardCoreDataStorage：好友名片（昵称，签名，性别，年龄等信息）在core data中的操作类
     xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
     */
    
    
    RXZXMPPvCardTempModule,
    /*
     XMPPvCardTemp：好友名片实体类，从数据库里取出来的都是它
     //头像临时缓存模块
     xmppvCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:xmppvCardStorage];
     [xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
     */
    
    
    RXZXMPPvCardStorage,
    /*
     //头像本地化管理
     xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
     */
    
    
    RXZXMPPvCardAvatarModule,
    /*
     xmppvCardAvatarModule：好友头像
     //名头像替身模块
     xmppvCardAvatarModule  = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:xmppvCardTempModule];
     
     [xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
     [xmppvCardAvatarModule activate:stream];

    */
    
    
    RXZXMPPReconnect,
    /*
     XMPPReconnect：如果失去连接,自动重连
     //自动重联
     reconnect = [[XMPPReconnect alloc]init];
     [reconnect setAutoReconnect:YES];
     [reconnect activate:stream];
     */
    
    
    RXZXMPPRoom,
    /*
       XMPPRoom：提供多用户聊天支持
     */
    
    
    RXZXMPPPubSub,
    /*
     XMPPPubSub：发布订阅
     */
    
    
    RXZXMPPCapabilitiesCoreDataStorage,
    /*
     xmpp实体能力本地化管理
     //xmpp实体化功能
     xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
     
     [xmppvCardAvatarModule activate:stream];
     */
    
    
    RXZXMPPCapabilities,
    /*
     //xmpp实体能力
     xmppCapabilities = [[XMPPCapabilities alloc]initWithCapabilitiesStorage:xmppCapabilitiesStorage];
     xmppCapabilities.autoFetchHashedCapabilities = YES;
     xmppCapabilities.autoFetchNonHashedCapabilities = NO;
     
     */
    
    
    RXZXMPPMessageArchivingCoreDataStorage,
    /*
     //聊天记录本地化存储
     //初始化message
     xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage  sharedInstance];
     
     */
    
    
    RXZXMPPMessageArchiving
    /*
     //聊天记录存储
     xmppMessageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
     [xmppMessageArchiving setClientSideMessageArchivingOnly:YES];//聊天记录自动归档
     [xmppMessageArchiving activate:stream];
     [xmppMessageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
     */
    
}wordDiscription;


typedef void(^RestoreViewBlock)(NSString *name);




@interface PublicFile : NSObject

+ (void)switchDiscriptionWithword:(wordDiscription)discription;

@end
