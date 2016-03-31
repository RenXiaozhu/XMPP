//
// Created by fengshuai on 15/10/8.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

//TODO:所有的工具类宏定义

#ifndef UTILITY_MACROS
#define UTILITY_MACROS

#pragma mark -仅在调试模式下打印日志

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//预定义日志等级
static int ddLogLevel;

//获取App当前版本
#define APP_VERSION [AppContext appVersion]


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//判断是否为3.5寸屏iPhone
#define IS_IPHONE_4 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480)
#define IS_IPHONE_5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define IS_IPHONE_6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)
#define IS_IPHONE_6P ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736)

//读取图片
#define GET_IMAGE_FROM_BUNDLE_PATH(imageName,bundleName) [ResBundleUtils imageNamedFromImagesBundlePNG:imageName withSubPath:bundleName]

//适配3.5寸屏和4寸品的图片名
#define ADAPT_IMAGE_NAME(imageName) (IS_IPHONE_5?[NSString stringWithFormat:@"%@-568h", [imageName stringByDeletingPathExtension]]: (IS_IPHONE_6?[NSString stringWithFormat:@"%@-667h", [imageName stringByDeletingPathExtension]]:imageName))


//屏幕宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

//屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

//屏幕宽比例
#define PROPORTION SCREEN_WIDTH/320
//屏幕宽比例
#define PROHEIGHTSCALE SCREEN_HEIGHT/480

//iPhone statusbar 高度
#define PHONE_STATUSBAR_HEIGHT  20

//导航栏高度
#define CONTENT_NAVIGATIONBAR_HEIGHT 44

//底部tabbar 高度
#define CONTENT_TABBAR_HEIGHT 49

//英文状态下键盘的高度
#define ENGISH_KEYBOARD_HEIGHT 216

//根据日期和序列号生成ActivityID
#define CREATE_ACTIVITY(date,seq)  [BleSpirit createActivityIDFromDate:date andSequance:seq]

//训练结束通知
#define TRAINNING_FINISH_NOTIFICATION @"TRAINNING_FINISH_NOTIFICATION"

#endif