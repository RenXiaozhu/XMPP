//
//  AppDelegate.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/11.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "BasicViewController.h"
#import "RootNavViewController.h"
#import "VideoPlayerStreamViewController.h"
#import "XMPPManager.h"
#import "BasicLoadingViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
 
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                          @"basic",@"name"
//                          ,[UIColor redColor],@"color",
//                          @"14",@"size",nil];
    
    BasicLoadingViewController *controller = [[BasicLoadingViewController alloc]init];
    
    self.window.rootViewController = controller;
    
    XMPPManager *manage = [XMPPManager sharedManager];
    [manage setGetUserBlock:^(NSArray *arr){
        DDLogInfo(@"%@",arr);
    }];
    [manage goOnline];
    
    [manage loginWithName:@"user3" Password:@"r185933685" completion:^(NSString *str){
        DDLogInfo(@"%@",str);
    }];
    
    
//  NSString *str = [self getDeviceCPUType];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (NSString *) getDeviceCPUType {
    
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86) {
        
        [cpu appendString:@"x86 "];
        // check for subtype ...
        
    } else if (type == CPU_TYPE_ARM) {
        
        [cpu appendString:@"ARM"];
        
        switch(subtype) {
                
            case CPU_SUBTYPE_ARM_V7F:
                
                [cpu appendString:@"V7"];
                break;
        }
        
    } else if (type == CPU_TYPE_ARM64) {
        
        [cpu appendString:@"ARM"];
        
        switch(subtype) {
                
            case CPU_SUBTYPE_ARM_V7:
                
                [cpu appendString:@"V7"];
                break;
                
            case CPU_SUBTYPE_ARM64_V8:
                
                [cpu appendString:@"ARM64_V8"];
                break;
        }
    } else if (type == CPU_TYPE_I386) {
        
        
    }
    return cpu;
}



- (LoginState)changeToStateWith:(LoginState)state ccount:(NSString *)userAccount password:(NSString *)userPassword
{
    switch (state)
    {
        case LogOut:
        {
            //发送下线状态
            XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
            [[self stream] sendElement:presence];
        }
            break;
        case logIn:
        {
            //发送上线状态
            XMPPPresence *presence = [XMPPPresence presence];
            [[self stream] sendElement:presence];
        }
            break;
        case goAway:
        {
            
        }
            break;
        case cloaking:
        {
            
        }
            break;
        default:
            break;
    }
    return LogOut;
    
}


#pragma mark - Roate Method
//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    UINavigationController *current = (RootNavViewController *)self.window.rootViewController;
////    if ([[UIDevice currentDevice] orientation]!=[current supportedInterfaceOrientations]) {
////        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
////            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)[current supportedInterfaceOrientations]];
////        }
////    }
//        return [current.visibleViewController supportedInterfaceOrientations];
//}
//



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    NSTimer *time = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(ddddd) userInfo:nil repeats:YES];
//    [time setFireDate:[NSDate distantPast]];
//    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
    
}

//- (void)ddddd
//{
//    DDLog(@"ooooooooooooooo");
//}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
