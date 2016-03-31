
//
//  YUDLoadingViewBase.m
//  SmartBascketball
//
//  Created by 任小柱 on 15/12/4.
//  Copyright © 2015年 yundongsports.com. All rights reserved.
//

#import "YUDLoadingViewBase.h"

@implementation YUDLoadingViewBase

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self UIConfig];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self UIConfig];
}

- (void)UIConfig
{
    self.userInteractionEnabled = NO;
    
    if (_activity == nil)
    {
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.center = self.center;
        [self addSubview:_activity];
    }
     _activity.center = self.center;
}

- (void)startLoading
{
    [_activity  startAnimating];
}

- (void)stopLoading
{
    [_activity stopAnimating];
}

@end
