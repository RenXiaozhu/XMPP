//
//  FriendListBaseModel.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/21.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "FriendListBaseModel.h"

@implementation FriendListBaseModel
@synthesize userId;
@synthesize userName;
@synthesize nowState;





- (void)dealloc
{
    [userName release];
    [userId release];
    [super dealloc];
}
@end
