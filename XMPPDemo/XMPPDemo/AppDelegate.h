//
//  AppDelegate.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/11.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPStream.h"
#import "LoginUser.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
  
}

@property (strong, nonatomic) UIWindow *window;



- (BOOL)connectToservce;

- (void)disconnectToservce;

- (LoginState)changeToStateWith:(LoginState)state ccount:(NSString *)userAccount password:(NSString *)userPassword;
@end

