//
//  LocalConfigurationFile.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalConfigurationFile : NSObject
{
    NSString *userAccount;
    NSString *userPassword;
    NSString *userToken;
    NSString *chatViewBgType;
    NSString *appDressUpTypeName;
    NSString *accountGrade;
    NSString *chatSoakBgType;
}

@property (nonatomic,retain) NSString *userAccount;        //用户账号
@property (nonatomic,retain) NSString *userPassword;       //用户密码
@property (nonatomic,retain) NSString *userToken;          //用户密匙
@property (nonatomic,retain) NSString *chatViewBgType;     //聊天窗口背景类型
@property (nonatomic,retain) NSString *appDressUpTypeName; //个性装扮类型
@property (nonatomic,retain) NSString *accountGrade;       //账号等级
@property (nonatomic,retain) NSString *chatSoakBgType;     //气泡背景类型


+ (LocalConfigurationFile *)shareManager;



- (NSDictionary *)getLocalEmotcionDict;

@end
