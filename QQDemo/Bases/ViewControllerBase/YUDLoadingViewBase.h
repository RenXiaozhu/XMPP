//
//  YUDLoadingViewBase.h
//  SmartBascketball
//
//  Created by 任小柱 on 15/12/4.
//  Copyright © 2015年 yundongsports.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YUDLoadingViewBase : UIView
@property (nonatomic, strong) UIActivityIndicatorView *activity;

- (void)startLoading;

- (void)stopLoading;

@end
