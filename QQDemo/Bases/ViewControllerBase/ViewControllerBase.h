//
// Created by fengshuai on 15/10/8.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUDLoadingViewBase.h"


typedef NS_ENUM(NSInteger,ControllerBackImgType){
    
    ControllerBackImgTypeNone,
    ControllerBackImgTypeDribble,
    ControllerBackImgTypePass,
    ControllerBackImgTypeShoot,
    ControllerBackImgTypeLogin,
    ControllerBackImgTypeProfile
    
};

@interface ViewControllerBase : UIViewController

@property(nonatomic, assign) BOOL leftBarButtonHidden;//是否隐藏左侧按钮

@property(nonatomic, assign) BOOL rightBarButtonHidden;//是否隐藏右侧按钮

@property(nonatomic, strong) UIView *customNavigationBar;

@property(nonatomic, strong) YUDLoadingViewBase *loadingView;

@property(nonatomic, strong) NSData *cutScreenData;//原图

@property(nonatomic, strong) NSData *thumbnail;//缩略图

- (void)leftButtonAction:(id)sender;//左侧按钮点击事件

//是否能回弹菜单
-(BOOL)canBePopedBack;


- (void)setBGColor:(NSString *)colorString;

/*
    0 为不设置
    1 运球背景
    2 传球背景
    3 投球背景
    4 登录背景
    5 成就背景
 
 */
- (void)setbackgroundImageWithIndex:(ControllerBackImgType)type;

/**
 *  @renxiaozhu yundongsports.com, 15-12-04 10:12:21
 *
 *  分享模块显示
 *
 *  @param block 功能实现
 */
- (void)showShareListWithBlock:(void (^)(NSInteger index))block;

- (void)hideShareList;

/**
 *  @renxiaozhu yundongsports.com, 15-12-04 10:12:43
 *
 *  加载提示
 */
- (void)showLoadingView;

- (void)hideLoadingView;

@end