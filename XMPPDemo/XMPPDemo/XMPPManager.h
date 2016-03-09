//
//  XMPPManager.h
//  XMPP
//
//  Created by T on 14-3-28.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "PublicFile.h"
#import "XMPPAutoPing.h"

typedef void (^FinBlock)(NSString* str);

@interface XMPPManager : NSObject<XMPPStreamDelegate,XMPPAutoPingDelegate>{
    XMPPStream* _stream;
    XMPPRoster* roster;
    XMPPRosterCoreDataStorage *rosterCoreDataStorage;
    XMPPReconnect *reconnect;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *xmppMessageArchiving;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPCapabilities *xmppCapabilities;
    XMPPAutoPing *autoPing;
    NSMutableArray *rosterArray;//好友列表
    NSMutableDictionary *messageRecordDic;//聊天信息读取写在认证通过里面
    NSMutableDictionary *messageSenders;  //相互发送消息的队列
    NSMutableDictionary *allUsersDataDic;  //所有用户信息
}

@property (nonatomic, strong) XMPPStream* stream;
@property (nonatomic,strong)  XMPPRoster* roster;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterCoreDataStorage;
@property (nonatomic, retain) XMPPReconnect *reconnect;
@property (nonatomic, retain) XMPPMessageArchivingCoreDataStorage *
                              xmppMessageArchivingCoreDataStorage;

@property (nonatomic,retain) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic,retain) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic,retain) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic,retain) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic,retain) XMPPCapabilitiesCoreDataStorage *
                                                   xmppCapabilitiesStorage;
@property (nonatomic,retain) XMPPCapabilities *xmppCapabilities;
@property (nonatomic,retain) XMPPAutoPing *autoPing;

@property (nonatomic,retain) NSMutableArray *rosterArray;//好友列表
@property (nonatomic,retain) NSMutableDictionary *messageRecordDic;//聊天信息读取写在认证通过里面
@property (nonatomic,retain) NSMutableDictionary *messageSenders;  //相互发送消息的队列
@property (nonatomic,retain) NSMutableDictionary *allUsersDataDic;  //所有用户信息

@property (nonatomic, copy) FinBlock registerBlock;
@property (nonatomic, copy) FinBlock loginBlock;
@property (nonatomic, copy) FinBlock sendMessageBlock;
@property (nonatomic, copy) void(^recvMessageBlock)(NSString* body,NSString* from);
@property (nonatomic, copy) void(^getUserBlock)(NSArray* array);


+ (XMPPManager*)sharedManager;

//上线
- (void)goOnline;

//下线
- (void)goOffline;

//注册
- (void)regWithName:(NSString*)name Password:(NSString*)password completion:(FinBlock)block;
//登录
- (void)loginWithName:(NSString*)name Password:(NSString*)password completion:(FinBlock)block;
//获得好友列表
- (void)getUserList:(void (^)(NSArray* array))block;
//添加好友
- (void)addUser:(NSString*)name;
//发送消息
- (void)sendMessage:(NSString*)str to:(NSString*)name completion:(FinBlock)block;
//得到消息
- (void)recvMessage:(void(^)(NSString* msg,NSString* from))block;



@end
