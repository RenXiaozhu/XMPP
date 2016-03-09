//
//  XMPPManager.m
//  XMPP
//
//  Created by T on 14-3-28.
//  Copyright (c) 2014年 PK. All rights reserved.
//

#import "XMPPManager.h"
#import "XMPPMessage.h"
#import "XMPPvCardTemp.h"

#define HOST @"hexun-pro.local"
//#define HOST @"pk.local"

static XMPPManager* manager = nil;
@implementation XMPPManager
@synthesize stream;
@synthesize roster;
@synthesize reconnect;
@synthesize rosterCoreDataStorage;
@synthesize xmppMessageArchiving;
@synthesize xmppMessageArchivingCoreDataStorage;
@synthesize xmppvCardStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppCapabilities;
@synthesize messageRecordDic;
@synthesize messageSenders;
@synthesize rosterArray;
@synthesize allUsersDataDic;
+ (XMPPManager *)sharedManager{
    if (manager == nil) {
        manager = [[XMPPManager alloc] init];
         
    }
    return manager;
}

- (id)init{
    if (self = [super init]) {
        [self initStream];
    }
    return self;
}

//添加创建连接方法
- (void)initStream{
    
    self.messageRecordDic = [[NSMutableDictionary alloc] init];//聊天信息的读取写在认证通过里面
    self.rosterArray =[[NSMutableArray alloc] initWithCapacity:10];
    self.messageSenders=[[NSMutableDictionary alloc] initWithCapacity:10];
    self.allUsersDataDic=[[NSMutableDictionary alloc] initWithCapacity:10];

    //xmpp数据流
    stream = [[XMPPStream alloc] init];
    stream.enableBackgroundingOnSocket = YES;//允许后台socket运行
    [stream setHostName:HOST];
    [stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //花名册本地化
    rosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc] init];
    roster = [[XMPPRoster alloc] initWithRosterStorage:rosterCoreDataStorage];
    roster.autoAcceptKnownPresenceSubscriptionRequests = YES;//自动接受认证请求
    roster.autoFetchRoster = YES;//自动获取好友列表
    [roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [roster activate:stream];
    
    //头像本地化管理
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    //头像临时缓存模块
    xmppvCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:xmppvCardStorage];
    //名头像替身模块
    xmppvCardAvatarModule  = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:xmppvCardTempModule];
    [xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //xmpp实体化功能
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc]initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    //初始化message
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage  sharedInstance];
    xmppMessageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchiving setClientSideMessageArchivingOnly:YES];//聊天记录自动归
    [xmppMessageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //自动重联
    reconnect = [[XMPPReconnect alloc]init];
    [reconnect setAutoReconnect:YES];
    
    
    //激活xmpp模块
    [reconnect activate:stream];
    [roster activate:stream];
    [xmppvCardTempModule activate:stream];
    [xmppvCardAvatarModule activate:stream];
    [xmppCapabilities activate:stream];
    [xmppMessageArchiving activate:stream];
}

//上线
- (void)goOnline{
    XMPPPresence* presene = [XMPPPresence presence];
    [stream sendElement:presene];
}

//下线
- (void)goOffline{
    XMPPPresence* presence = [XMPPPresence presenceWithType:@"unavailable"];
    [stream sendElement:presence];
    [stream disconnect];
}

//注册
- (void)regWithName:(NSString *)name Password:(NSString *)password completion:(FinBlock)block{
    if (self.registerBlock)
    {
        Block_release(self.registerBlock);
    }
    self.registerBlock = block;
    self.password = password;
    
    if (stream.isConnected) {
        [self goOffline];
    }

    stream.tag = @"注册";
    [stream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,HOST]]];
//    [stream connectWithTimeout:30 error:nil];
    NSError *error ;
    if (![stream connectWithTimeout:-1 error:&error]) {
        NSLog(@"my connected error : %@",error.description);
    
    }
    
}

//登录
- (void)loginWithName:(NSString *)name Password:(NSString *)password completion:(FinBlock)block{
    if (self.loginBlock)
    {
        Block_release(self.loginBlock);
    }
    self.loginBlock = block;
    self.name = name;
    self.password = password;
    stream.hostName = HOST;
    stream.hostPort = 5222;
    if (stream.isConnected) {
        [self goOnline];
    }
    
    stream.tag = @"登录";
    [stream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.name,HOST]]];
//    [stream connectWithTimeout:30 error:nil];
    NSError *error ;
    if (![stream connectWithTimeout:-1 error:&error])
    {
        NSLog(@"my connected error : %@",error.description);
        
    }
}

//得到用户列表
- (void)getUserList:(void (^)(NSArray *))block{
    
    if (self.getUserBlock)
    {
        Block_release(self.getUserBlock);
    }
    self.getUserBlock = block;
    
    XMPPIQ* iq = [XMPPIQ iqWithType:@"get" to:[XMPPJID jidWithString:HOST]];
    [iq setXmlns:@"jabber:client"];
    NSXMLElement* query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:user1"];
    [iq addChild:query];
    [stream sendElement:iq];
   
    [roster fetchRoster];
}

//添加用户
- (void)addUser:(NSString *)name{
    [roster subscribePresenceToUser:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,HOST]]];
}

//发送消息
- (void)sendMessage:(NSString*)str to:(NSString *)name completion:(FinBlock)block{
    if (self.sendMessageBlock)
    {
        Block_release(self.sendMessageBlock);
    }
    self.sendMessageBlock = block;
   
    XMPPMessage* message = [XMPPMessage messageWithType:@"chat"];
    [message addAttributeWithName:@"to" stringValue:name];
    NSXMLElement* body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:str];
    [message addChild:body];
    [stream sendElement:message];
}

#pragma MessageDelegate
//得到消息
- (void)recvMessage:(void (^)(NSString *, NSString *))block{
    if (self.recvMessageBlock)
    {
        Block_release(self.recvMessageBlock);
    }
    self.recvMessageBlock = block;
    
    
}


//xmpp delegate

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    FinBlock block = [self.sendMessageBlock retain];
    if (block)
    {
        block(@"发送成功");
    }
    [block release];
    NSLog(@"%@",message.XMLString);
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    NSLog(@"%@",message.XMLString);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
  //  NSLog(@"%@",message.XMLString);
    NSString* to = [[[message attributeStringValueForName:@"to"] componentsSeparatedByString:@"/"] objectAtIndex:0];
    if (message.children.count > 0) {
        NSArray* children = [message children];
        for (XMPPElement* body in children) {
            if ([body.name isEqualToString:@"body"]) {
             //   NSLog(@"%@",body.stringValue);
                if (self.recvMessageBlock) {
                    self.recvMessageBlock(body.stringValue, to);
                }
                
            }
        }
    }
    
    //self.recvMessageBlock(body,to);
}



- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    NSMutableArray* array = [NSMutableArray array];
    for (NSXMLElement* item in iq.childElement.children) {
        NSString* jid = [item attributeStringValueForName:@"jid"];
        [array addObject:jid];
    }
    if (array.count > 0) {
        self.getUserBlock(array);
    }
    return YES;
}


- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    CLog(@"xmppStreamWillConnect");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    if ([sender.tag isEqualToString:@"注册"]) {
        [sender registerWithPassword:self.password error:nil];
    }
    if ([sender.tag isEqualToString:@"登录"]) {
        [sender authenticateWithPassword:self.password error:nil];
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
//    [self goOnline];
    FinBlock block = [self.loginBlock retain];
    self.stream = sender;
    if (block)
    {
        block(@"登陆成功");
    }
    [block release];
    
    [self goOnline];
    
    autoPing = [[XMPPAutoPing alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    autoPing.pingInterval = 10.0;
    autoPing.pingTimeout = 15.0;
    autoPing.targetJID = sender.myJID;
    [autoPing activate:self.stream];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    FinBlock block = [self.loginBlock retain];
    if (block)
    {
        block(@"登陆失败");
    }
    [block release];
    
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    FinBlock block = [self.registerBlock retain];
    if (block)
    {
        block(@"注册成功");
    }
    [block release];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    FinBlock block = [self.registerBlock retain];
    if (block)
    {
        block(@"注册失败");
    }
    [block release];
    
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    CLog(@"%@",error);
}


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    [roster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
}

- (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(NSXMLElement *)item
{

    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",[item attributeStringValueForName:@"jid"]]];
    [self fetchvCardTempForJID:jid];
}
//获取完好友列表
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    
}
//到服务器上请求联系人名片信息
- (void)fetchvCardTempForJID:(XMPPJID *)jid
{
    [xmppvCardTempModule fetchvCardTempForJID:jid];
}
//请求联系人的名片，如果数据库有就不请求，没有就发送名片请求
- (void)fetchvCardTempForJID:(XMPPJID *)jid ignoreStorage:(BOOL)ignoreStorage
{
    [xmppvCardTempModule fetchvCardTempForJID:jid ignoreStorage:ignoreStorage];
}
//获取联系人的名片，如果数据库有就返回，没有返回空，并到服务器上抓取
- (XMPPvCardTemp *)vCardTempForJID:(XMPPJID *)jid shouldFetch:(BOOL)shouldFetch
{
    if (shouldFetch)
    {
        [roster fetchRoster];
    }
    else
    {
        XMPPvCardTemp *temp = [xmppvCardStorage vCardTempForJID:jid xmppStream:stream];
        return temp;
    }
    
    return nil;
}
//更新自己的名片信息
- (void)updateMyvCardTemp:(XMPPvCardTemp *)vCardTemp
{
    [xmppvCardTempModule updateMyvCardTemp:vCardTemp];
}

#pragma xmppvCardTempModuleDelegate
//获取到一盒联系人的名片信息的回调
- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error
{
    
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
}

/**
 * Sent when a Roster Push is received as specified in Section 2.1.6 of RFC 6121.
 **/
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq
{

}

/**
 * Sent when the initial roster is received.
 **/
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{

}





@end
