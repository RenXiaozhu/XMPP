//
//  ExplainFile.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/22.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

/*
 UIButton *voiceChat = (UIButton *)[leftView viewWithTag:1001];
 
 NSLayoutConstraint *constraintW = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
 [leftView addConstraint:constraintW];
 
 NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
 [leftView addConstraint:constraintY];
 
 
 NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
 [self addConstraint:constraintLeft];
 
 NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
 [self addConstraint:constraintBottom];
 
 NSLayoutConstraint *constraintLt = [NSLayoutConstraint constraintWithItem:voiceChat attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
 [leftView addConstraint:constraintLt];
 
 NSLayoutConstraint *constraintBm = [NSLayoutConstraint constraintWithItem:voiceChat attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
 [leftView addConstraint:constraintBm];
 
 NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:voiceChat attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
 [leftView addConstraint:constraintTop];
 
 NSLayoutConstraint *constraintRt = [NSLayoutConstraint constraintWithItem:voiceChat attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
 [leftView addConstraint:constraintRt];
 
 NSLayoutConstraint *constraintWV = [NSLayoutConstraint constraintWithItem:rightV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
 [rightV addConstraint:constraintWV];
 
 NSLayoutConstraint *constraintYV = [NSLayoutConstraint constraintWithItem:rightV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
 [rightV addConstraint:constraintYV];
 
 NSLayoutConstraint *constraintLeftV = [NSLayoutConstraint constraintWithItem:rightV attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
 [self addConstraint:constraintLeftV];
 
 NSLayoutConstraint *constraintBottomV = [NSLayoutConstraint constraintWithItem:rightV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
 [self addConstraint:constraintBottomV];
 
 UIButton *emoticonBtn = (UIButton *)[rightV viewWithTag:1002];
 UIButton *functionBtn = (UIButton *)[rightV viewWithTag:1003];
 
 NSLayoutConstraint *eConstraintLt = [NSLayoutConstraint constraintWithItem:emoticonBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rightV attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
 [rightV addConstraint:eConstraintLt];
 
 NSLayoutConstraint *eConstraintBm = [NSLayoutConstraint constraintWithItem:emoticonBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rightV attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
 [rightV addConstraint:eConstraintBm];
 
 NSLayoutConstraint *eConstraintTop = [NSLayoutConstraint constraintWithItem:emoticonBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rightV attribute:NSLayoutAttributeTop multiplier:1 constant:0];
 [rightV addConstraint:eConstraintTop];
 
 NSLayoutConstraint *eConstraintRt = [NSLayoutConstraint constraintWithItem:voiceChat attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightV attribute:NSLayoutAttributeRight multiplier:1 constant:40];
 [rightV addConstraint:eConstraintRt];
 */

#ifndef XMPPDemo_ExplainFile_h
#define XMPPDemo_ExplainFile_h
/*
 
 XMPP中常用对象们：
 
 
 
 XMPPStream：xmpp基础服务类
 
 
 
 XMPPRoster：好友列表类
 
 
 
 XMPPRosterCoreDataStorage：好友列表（用户账号）在core data中的操作类
 
 
 
 XMPPvCardCoreDataStorage：好友名片（昵称，签名，性别，年龄等信息）在core data中的操作类
 
 XMPPvCardTemp：好友名片实体类，从数据库里取出来的都是它
 xmppvCardAvatarModule：好友头像
 
 
 
 XMPPReconnect：如果失去连接,自动重连
 
 XMPPRoom：提供多用户聊天支持
 
 XMPPPubSub：发布订阅
 
 
 XMPP协议的组成
 
 主要的XMPP 协议范本及当今应用很广的XMPP 扩展：
 
 RFC 3920 XMPP：核心。定义了XMPP 协议框架下应用的网络架构，引入了XML Stream（XML 流）与XML Stanza（XML 节），并规定XMPP 协议在通信过程中使用的XML 标签。使用XML 标签从根本上说是协议开放性与扩展性的需要。此外，在通信的安全方面，把TLS 安全传输机制与SASL 认证机制引入到内核，与XMPP 进行无缝的连接，为协议的安全性、可靠性奠定了基础。Core 文档还规定了错误的定义及处理、XML 的使用规范、JID（Jabber Identifier，Jabber 标识符）的定义、命名规范等等。所以这是所有基于XMPP 协议的应用都必需支持的文档。
 
 RFC 3921：用户成功登陆到服务器之后，发布更新自己的在线好友管理、发送即时聊天消息等业务。所有的这些业务都是通过三种基本的XML 节来完成的：IQ Stanza（IQ 节）, Presence Stanza（Presence 节）, Message Stanza（Message 节）。RFC3921 还对阻塞策略进行了定义，定义是多种阻塞方式。可以说，RFC3921 是RFC3920 的充分补充。两个文档结合起来，就形成了一个基本的即时通信协议平台，在这个平台上可以开发出各种各样的应用。
 
 XEP-0030 服务搜索。一个强大的用来测定XMPP 网络中的其它实体所支持特性的协议。
 
 XEP-0115 实体性能。XEP-0030 的一个通过即时出席的定制，可以实时改变交变广告功能。
 
 XEP-0045 多人聊天。一组定义参与和管理多用户聊天室的协议，类似于Internet 的Relay Chat，具有很高的安全性。
 
 XEP-0096 文件传输。定义了从一个XMPP 实体到另一个的文件传输。
 
 XEP-0124 HTTP 绑定。将XMPP 绑定到HTTP 而不是TCP，主要用于不能够持久的维持与服务器TCP 连接的设备。
 
 XEP-0166 Jingle。规定了多媒体通信协商的整体架构。
 
 XEP-0167 Jingle Audio Content Description Format。定义了从一个XMPP 实体到另一个的语音传输过程。
 
 XEP-0176 Jingle ICE（Interactive Connectivity Establishment）Transport。ICE传输机制，文件解决了如何让防火墙或是NAT（Network Address Translation）保护下的实体建立连接的问题。
 
 XEP-0177 Jingle Raw UDP Transport。纯UDP 传输机制，文件讲述了如何在没有防火墙且在同一网络下建立连接的。
 
 XEP-0180 Jingle Video Content Description Format。定义了从一个XMPP 实体到另一个的视频传输过程。
 
 XEP-0181 Jingle DTMF（Dual Tone Multi-Frequency）。
 
 XEP-0183 Jingle Telepathy Transport Method。
 
 一.   XMPPFramework几个常用到的扩展。
 
 协议列表：
 
 协议
	
 
 协议简介
 
 XEP-0009
	
 
 在两个XMPP实体间传输XML-RPC编码请求和响应
 
 XEP-0006
	
 
 使能与网络上某个XMPP实体间的通信
 
 XEP-0045
	
 
 多人聊天相关协议
 
 XEP-0054
	
 
 名片格式的标准文档  http://wiki.jabbercn.org/XEP-0054
 
 XEP-0060
	
 
 提供通用公共订阅功能
 
 XEP-0065
	
 
 两个XMPP用户之间建立一个带外流，主要用于文件传输
 
 XEP-0082
	
 
 日期和时间信息的标准化表示
 
 XEP-0084
	
 
 用于交换用户头像,一个小的和自然人用户相关的图像或图标.
 
 该协议定义了头像元数据和图像数据本身的承载格式.
 
 承载格式典型地使用定义于XEP-0163的 XMPP发布-订阅个人事件脚本
 
 协议来传输
 
 XEP-0085
	
 
 聊天对话中通知用户状态
 
 XEP-0100
	
 
 表述了XMPP客户端与提供传统的IM服务的代理网关之间交换的最佳实践
 
 XEP-0115
	
 
 广播和动态发现客户端、设备、或一般实体能力。
 
 XEP-0136
	
 
 为服务端备份和检索XMPP消息定义机制和偏好设置
 
 XEP-0153
	
 
 用于交换用户头像
 
 XEP-0184
	
 
 消息送达回执协议
 
 XEP-0199
	
 
 XMPP ping 协议
 
 XEP-0202
	
 
 用于交换实体间的本地时间信息
 
 XEP-0203
	
 
 用于延迟发送
 
 XEP-0224
	
 
 引起另一个用户注意的协议
 
 
 基本的jabber客户端必须实现以下标准协议（XEP-0211）
 1、RFC3920 Core http://tools.ietf.org/html/rfc3920
 2、RFC3921 Instant Messaging and Presence http://tools.ietf.org/html/rfc3921
 3、XEP-030 Service Discovery http://www.xmpp.org/extensions/xep-0030.html
 4、XEP-0115 Entity Capabilities http://www.xmpp.org/extensions/xep-0115.html
 
 基本的jabber服务器必须实现以下标准协议(XEP-0212)
 1、RFC3920 Core http://tools.ietf.org/html/rfc3920
 2、RFC3921 Instant Messaging and Presence http://tools.ietf.org/html/rfc3921
 3、XEP-030 Service Discovery http://www.xmpp.org/extensions/xep-0030.html
 
 一、注册
 XEP-0077 In-Band Registration http://www.xmpp.org/extensions/xep-0077.html
 二、登录
 XEP-0020 Software Version http://www.xmpp.org/extensions/xep-0092.html
 三、好友列表
 XEP-0083 Nested Roster Groups http://www.xmpp.org/extensions/xep-0083.html
 1、获取好友列表
 2、存储好友列表
 XEP-0049 Private XML Storage http://www.xmpp.org/extensions/xep-0049.html
 3、备注好友信息
 XEP-0145 Annotations http://www.xmpp.org/extensions/xep-0145.html
 4、存储书签
 XEP-0048 Bookmark Storage http://www.xmpp.org/extensions/xep-0048.html
 5、好友头像
 XEP-0008 IQ-Based Avatars http://www.xmpp.org/extensions/xep-0008.html
 XEP-0084 User Avatar http://www.xmpp.org/extensions/xep-0084.html
 XEP-0054 vcard-temp http://www.xmpp.org/extensions/xep-0054.html
 四、用户状态
 RFC-3921 Subscription States http://www.ietf.org/rfc/rfc3921.txt
 五、文本消息
 1、在线消息
 2、离线消息
 XEP-0013 Flexible Offline Message Retrieval http://www.xmpp.org/extensions/xep-0013.html
 XEP-0160 Best Practices for Handling Offline Messages http://www.xmpp.org/extensions/xep-0160.html
 XEP-0203 Delayed Delivery http://www.xmpp.org/extensions/xep-0203.html
 3、聊天状态通知
 XEP-0085 Chat State Notifications http://www.xmpp.org/extensions/xep-0085.html
 六、群组聊天
 1、XEP-0045 Multi-User Chat http://www.xmpp.org/extensions/xep-0045.html
 七、文件传输
 1、XEP-0095 Stream Initiation http://www.xmpp.org/extensions/xep-0095.html
 2、XEP-0096 File Transfer http://www.xmpp.org/extensions/xep-0096.html
 3、XEP-0065 SOCKS5 Bytestreams http://www.xmpp.org/extensions/xep-0065.html
 4、XEP-0215 STUN Server Discovery for Jingle http://www.xmpp.org/extensions/xep-0215.html
 5、RFC-3489 STUN http://tools.ietf.org/html/rfc3489
 
 八、音视频会议
 1、XEP-0166 Jingle http://www.xmpp.org/extensions/xep-0166.html#negotiation
 2、XEP-0167 Jingle Audio via RTP http://www.xmpp.org/extensions/xep-0167.html
 3、XEP-0176 Jingle ICE Transport http://www.xmpp.org/extensions/xep-0176.html
 4、XEP-0180 Jingle Video via RTP http://www.xmpp.org/extensions/xep-0180.html#negotiation
 5、XEP-0215 STUN Server Discovery for Jingle http://www.xmpp.org/extensions/xep-0215.html
 6、RFC-3489 STUN http://tools.ietf.org/html/rfc3489
 
 九、用户查询
 XEP-0055 Jabber Search http://www.xmpp.org/extensions/xep-0055.html
 
 十、用户保活 (peakflys增加)
 XEP-0199 Ping http://xmpp.org/extensions/xep-0199.html
 
 整体：
 一、协议数据交互
 XEP-0004 Data Forms http://www.xmpp.org/extensions/xep-0004.html
 二、jabber-RPC
 XEP-0009 Jabber-RPC http://www.xmpp.org/extensions/xep-0009.html
 三、功能协商
 XEP-0020 Feature Negotiation http://www.xmpp.org/extensions/xep-0020.html
 四、服务发现
 XEP-0030 Service Discovery http://www.xmpp.org/extensions/xep-0030.html
 五、会话建立
 XEP-0116 Encrypted Session Negotiation http://www.xmpp.org/extensions/xep-0116.html
 XEP-0155 Stanza Session Negotiation http://www.xmpp.org/extensions/xep-0155.html
 XEP-0201 Best Practices for Message Threads http://www.xmpp.org/extensions/xep-0201.html
 
 XMPP协议网络架构
 
 XMPP是一个典型的C/S架构，而不是像大多数即时通讯软件一样，使用P2P客户端到客户端的架构，也就是说在大多数情况下，当两个客户端进行通讯时，他们的消息都是通过服务器传递的(也有例外，例如在两个客户端传输文件时)．采用这种架构，主要是为了简化客户端，将大多数工作放在服务器端进行，这样，客户端的工作就比较简单，而且，当增加功能时，多数是在服务器端进行．XMPP服务的框架结构如下图所示．XMPP中定义了三个角色，XMPP客户端，XMPP服务器、网关．通信能够在这三者的任意两个之间双向发生．服务器同时承担了客户端信息记录、连接管理和信息的路由功能．网关承担着与异构即时通信系统的互联互通，异构系统可以包括SMS(短信)、MSN、ICQ等．基本的网络形式是单客户端通过TCP／IP连接到单服务器，然后在之上传输XML，工作原理是：
 
 (1)节点连接到服务器；(2)服务器利用本地目录系统中的证书对其认证；(3)节点指定目标地址，让服务器告知目标状态；(4)服务器查找、连接并进行相互认证；(5)节点之间进行交互．
 
 XMPP客户端
 
 XMPP 系统的一个设计标准是必须支持简单的客户端。事实上，XMPP 系统架构对客户端只有很少的几个限制。一个XMPP 客户端必须支持的功能有：
 
 1. 通过 TCP 套接字与XMPP 服务器进行通信；
 
 2. 解析组织好的 XML 信息包；
 
 3. 理解消息数据类型。
 
 XMPP 将复杂性从客户端转移到服务器端。这使得客户端编写变得非常容易，更新系统功能也同样变得容易。XMPP 客户端与服务端通过XML 在TCP 套接字的5222 端口进行通信，而不需要客户端之间直接进行通信。
 
 基本的XMPP 客户端必须实现以下标准协议（XEP-0211）：
 
 RFC3920 核心协议Core
 
 RFC3921 即时消息和出席协议Instant Messaging and Presence
 
 XEP-0030 服务发现Service Discovery
 
 XEP-0115 实体能力Entity Capabilities
 
 
 
 XMPP服务器
 
 
 
 XMPP 服务器遵循两个主要法则：
 
 l  监听客户端连接，并直接与客户端应用程序通信；
 
 l  与其他 XMPP 服务器通信；
 
 XMPP开源服务器一般被设计成模块化，由各个不同的代码包构成，这些代码包分别处理Session管理、用户和服务器之间的通信、服务器之间的通信、DNS（Domain Name System）转换、存储用户的个人信息和朋友名单、保留用户在下线时收到的信息、用户注册、用户的身份和权限认证、根据用户的要求过滤信息和系统记录等。另外，服务器可以通过附加服务来进行扩展，如完整的安全策略，允许服务器组件的连接或客户端选择，通向其他消息系统的网关。
 
 基本的XMPP 服务器必须实现以下标准协议
 
 RFC3920 核心协议Core
 
 RFC3921 即时消息和出席协议Instant Messaging and Presence
 
 XEP-0030 服务发现Service Discovery
 
 
 
 XMPP网关
 
 
 
 XMPP 突出的特点是可以和其他即时通信系统交换信息和用户在线状况。由于协议不同，XMPP 和其他系统交换信息必须通过协议的转换来实现，目前几种主流即时通信协议都没有公开，所以XMPP 服务器本身并没有实现和其他协议的转换，但它的架构允许转换的实现。实现这个特殊功能的服务端在XMPP 架构里叫做网关(gateway)。目前，XMPP 实现了和AIM、ICQ、IRC、MSN Massager、RSS0.9 和Yahoo Massager 的协议转换。由于网关的存在，XMPP 架构事实上兼容所有其他即时通信网络，这无疑大大提高了XMPP 的灵活性和可扩展性。
 
 
 
 XMPP地址格式
 
 一个实体在XMPP网络结构中被称为一个接点，它有唯一的标示符jabber identifier(JID)，即实体地址，用来表示一个Jabber用户，但是也可以表示其他内容，例如一个聊天室．一个有效的JID包括一系列元素：(1)域名(domain identifier)；(2)节点(node identifier)；(3)源(resource identifier)．它的格式是node@domain/resource，node@domain，类似电子邮件的地址格式．domain用来表示接点不同的设备或位置，这个是可选的，例如a在Server1上注册了一个用户，用户名为doom，那么a的JID就是doom@serverl，在发送消息时，指明doom@serverl就可以了，resource可以不用指定，但a在登录到这个Server时，fl的JID可能是doom@serverl、exodus(如果a用Exodus软件登录)，也可能是doom@serverl/psi(如果a用psi软件登录)．资源只用来识别属于用户的位置或设备等，一个用户可以同时以多种资源与同一个XMPP服务器连接。
 
 
 
 XMPP消息格式
 XMPP中定义了       3个顶层XML元素: Message、Presence、IQ，下面针对这三种元素进行介绍。
 
 
 
 <Message>
 
 用于在两个jabber用户之间发送信息。Jsm(jabber会话管理器)负责满足所有的消息，不管目标用户的状态如何。如果用户在线jsm立即提交;否则jsm就存储。
 
 To :标识消息的接收方。
 
 from : 指发送方的名字或标示(id)o
 
 Text: 此元素包含了要提交给目标用户的信息。
 
 结构如下所示:
 
 
 
 <message to= ‘lily@jabber.org/contact’ type =’chat’>
 
 <body> 你好，在忙吗</body>
 
 </message>
 
 
 
 <Presence>
 
 用来表明用户的状态，如：online、away、dnd(请勿打扰)等。当用户离线或改变自己的状态时，就会在stream的上下文中插入一个Presence元素，来表明自身的状态．结构如下所示：
 
 <presence>
 
 From =‘lily @ jabber.com/contact’
 
 To = ‘yaoman @ jabber.com/contact'
 
 <status> Online </status>
 
 </presence>
 
 <presence>元素可以取下面几种值:
 
 Probe :用于向接受消息方法发送特殊的请求
 
 subscribe:当接受方状态改变时，自动向发送方发送presence信息。
 
 
 
 
 
 < IQ >
 
 一种请求／响应机制，从一个实体从发送请求，另外一个实体接受请求，并进行响应．例如，client在stream的上下文中插入一个元素，向Server请求得到自己的好友列表，Server返回一个，里面是请求的结果．
 
 <iq > 主要的属性是type。包括:
 
 Get :获取当前域值。
 
 Set :设置或替换get查询的值。
 
 Result :说明成功的响应了先前的查询。
 
 Error: 查询和响应中出现的错误。
 
 结构如下所示:
 
 <iq from =‘lily @ jabber.com/contact’id=’1364564666’ Type=’result’>
 
 */

#endif
