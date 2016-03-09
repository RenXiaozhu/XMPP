//
//  FriendListBaseModel.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/21.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicFile.h"

@interface FriendListBaseModel : NSObject

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) LoginState nowState;


@end
