//
//  RootViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/11.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"

@interface RootViewController : UIViewController

{
    //    UIView *errorToastView;
    UIImageView *errorLoad;
    UIButton *reloadButton;
    UIView *loadingView;
    UIActivityIndicatorView *myActivityIndicatorView;
}
//@property (nonatomic,retain)     UIView *errorToastView;
@property (nonatomic,retain) UIImageView *errorLoad;
@property (nonatomic,retain) UIButton *reloadButton;
@property (nonatomic,retain) UIActivityIndicatorView *myActivityIndicatorView;
@property (nonatomic,retain) UIView *loadingView;
@property (nonatomic,retain)UITableView *tView;

- (id)init;
- (void)initValuesWithName:(NSDictionary *)dictVaule BGColor:(UIColor *)color NavgationBarBgColor:(NSString *)imgName;
- (void)initViews;
//- (void)didLoadInitView;
- (void)reloadNewsData;//重载数据
- (void)showErrorToast:(CGRect)rect withStr:(NSString *)str;//显示提示框
- (void)showReloadView:(BOOL) DataOrEvent;//显示加载失败视图
- (void)hiddenReloadView;//
- (BOOL)isConnect;//判断网络连接
- (void)startMyActivityIndicatorView;
- (void)stopAllActivityIndicatorView;//停止UIActivityIndicatorView

@end
