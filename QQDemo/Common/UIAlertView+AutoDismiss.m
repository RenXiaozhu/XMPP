//
// Created by fengshuai on 15/4/1.
// Copyright (c) 2015 com.8f8. All rights reserved.
//

#import "UIAlertView+AutoDismiss.h"


@implementation UIAlertView (AutoDismiss)

- (void)showWithAutoDismiss
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWhenDeactived) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self show];
}

-(void)dismissWhenDeactived
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissWithClickedButtonIndex:-1 animated:NO];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end